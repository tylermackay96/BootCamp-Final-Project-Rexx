/* Prompt user for search term */
say "Enter a search term:"
pull search_term

/* Read Wikipedia API key from file */
api_key_file = 'api_key.txt'
if sysdsn(api_key_file) then do
  api_key = linein(api_key_file)
end
else do
  say "Error: API key file not found."
  exit
end

/* Construct URL for Wikipedia API */
url = "https://en.wikipedia.org/w/api.php?action=query&format=json&list=search&srsearch=" || search_term || "&utf8=&formatversion=2&origin=*&srlimit=10"

/* Call Wikipedia API and retrieve results */
json_result = jsonparse(httpget(url))
if json_result = '' | json_result = .nil then do
  say "Error: Failed to retrieve search results from Wikipedia API."
  exit
end

/* Parse JSON result and format output */
if json_result.query.searchinfo.totalhits == 0 then do
  say "No results found for search term:" search_term
end

else do
  i = 1 to json_result.query.search.items()
    title = json_result.query.search.items(i).title
    snippet = json_result.query.search.items(i).snippet
    url = "https://en.wikipedia.org/wiki/" translate(title)
    say "Result " i " - " title " - " url " - " snippet
  end
