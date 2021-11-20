# parse and check grammar

require_relative 'grammarclasses'


def correct_message(msg)
    # pass discord message object
    message = MESSAGE.new(msg)
    return nil unless message.containstarget
    # language processing time baby
    # 
    # take surrounding words, decide which form should be used
    # compare the written word to what is correct, return FAILED_RESULT if wrong
    targets = ["your", "you're", "youre", "there", "their", "they're", "theyre"]
    failures = []
    targetindices = []
    message.words.each_with_index do |sentence, index|
        sentence.each_with_index do |word, ind|
            targetindices << [index, ind] if word.crit?
        end
    end
    targetindices.each do |ind|
        crit = message.words[ind[0]][ind[1]].word
        sentence = message.words[ind[0]]
        if(ind[1] == sentence.length - 1)
       		next
        end
        if(crit == "you're" || crit == "youre")
            # only followed by adverb or adjective, must not have a noun immediately after adj
            # iter starting at the crit word to the end, if there is a noun immediately following adj
            # then its wrong
            # if the word is at the very end ignore this crit
			if(!(sentence[ind[1] + 1].parts["parts"].include? "adjective") && (sentence[ind[1] + 1].parts["parts"].include? "noun"))
				failures << FAILED_RESULT.new("your")
			elsif(sentence[ind[1] + 1].parts["parts"].include? "adverb")
				begin
					if(!(sentence[ind[1] + 1].parts["parts"].include? "adjective") && (sentence[ind[1] + 2].parts["parts"].include? "noun"))
						failures << FAILED_RESULT.new("unknown")
					end
				rescue
				end
				next
			elsif(sentence[ind[1] + 1].parts["parts"].include? "adjective")
				begin
					if(!(sentence[ind[1] + 1].parts["parts"].include? "adjective") && (sentence[ind[1] + 2].parts["parts"].include? "noun"))
						failures << FAILED_RESULT.new("your")
					end
				rescue
				end
				next
			end
			failures << FAILED_RESULT.new("unknown")
		elsif(crit == "your")
			# can be followed by adv, adj, and noun
			# can only be followed by adv and adj if followed by noun
			if(sentence[ind[1] + 1].parts["parts"].include? "adjective")
				begin
					if(sentence[ind[1] + 2].parts["parts"].include? "noun")
						next
					else
						failures << FAILED_RESULT.new("you're")
					end
				rescue
					failures << FAILED_RESULT.new("you're")
				end
			end
        end
    end
    failures
end
