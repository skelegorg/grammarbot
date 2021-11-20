require 'json'
require_relative 'utils'

class MESSAGE
    # consists of word objects
    def initialize(msg)
        # tokenize message
        @containstarget = false
        @targetindex = nil
        @typos = 0
        targets = ["your", "you're", "youre", "there", "their", "they're", "theyre"]
        abbreviations = [
        	"idk", "idfk", "idts", "btw", "bc", "fyi", "lol", "lmao", "lmfao", "lolmao", "rofl", "stfu", "lmk", "tbh", "ngl", 
        	"tldr", "tl;dr", "imo", "rn", "tbf", "hmu", "tbd", "brb", "np", "ty", "aka", "ily", "bf", "gf", "u", "r", "y",
			"kekw", "ur" 
        ]
        msg = msg.split(".")
        fmsg = []
        msg.each do |sentence|
            fmsg << sentence.split(" ")
        end
        msg = fmsg
        sentences = []
        msg.each do |sentence|
            ws = []
            sentence.each do |word|
                if(targets.include? word)
                    @containstarget = true
                end
                worddef = lookup(word)
                if(worddef)
                    ws << WORD.new(word, worddef)
                else
                    uri = "https://api.dictionaryapi.dev/api/v2/entries/en/#{word}"
                    begin
                    	worddefs = JSON.parse(request(uri).body.force_encoding("UTF-8")).first["meanings"]
					rescue
						ws << WORD.new(word, [nil])
						if(!(abbreviations.include? word))
							@typos += 1
						end
						next
					end
                    partsofspeech = []
                    worddefs.each do |defobj|
                        partsofspeech << defobj["partOfSpeech"]
                    end
                    define(word, partsofspeech)
                    ws << WORD.new(word, partsofspeech)
                end
            end
            sentences << ws
        end
        @words = sentences
    end
    def words
    	@words
    end
    def containstarget
    	@containstarget 
    end
end

class WORD
    # consists of word, part of speech
    def initialize(w, p)
        @word = w
        @pos = p
    end
    def word() @word end
    def parts() @pos end
    def crit?
        targets = ["your", "you're", "youre", "there", "their", "they're", "theyre"]
        return true if targets.include?(@word)
    end
end

class FAILED_RESULT
    def initialize(c)
        @correct = c
    end
    def
    	correct() @correct 
    end
end
