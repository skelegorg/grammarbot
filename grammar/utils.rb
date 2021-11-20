# utility functions
require 'uri'
require 'net/http'
require 'json'

# request
def request(url)
    uri = URI(url)
    res = Net::HTTP.get_response(uri)
    return res if res.is_a?(Net::HTTPSuccess)
    return nil
end

# internal word lookup
def lookup(word)
    file = File.open("dict.json")
    filedata = file.read
    dictionary = JSON.parse(filedata)
    return dictionary[word] if dictionary[word]
    return nil
end

# append to builtin dict
def define(word, pos)
    # add to thing
    file = File.open("dict.json")
    dictionary = JSON.parse(file.read)
    file.close
    dictionary[word] = {parts: pos}
    newdict = dictionary.to_json
    file = File.open("dict.json", "w")
    file.write(newdict)
    file.close
end