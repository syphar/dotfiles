-- uppercase spaces would stop the upper case motion (full words)
vim.g.wordmotion_uppercase_spaces = { ".", ",", "(", ")", "[", "]", "{", "}", " ", "<", ">", ":" }
-- normal spaces would stop the lower-case (x-case subword) motion
-- let g:wordmotion_spaces = ['\w\@<=-\w\@=', '\.']
