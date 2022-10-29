local ok, impatient = pcall(require, "impatient")
if ok then
  impatient.enable_profile()
else
  vim.notify(impatient)
end

-- Fazer tudo em config para usar o cache do impatient
require("config")
