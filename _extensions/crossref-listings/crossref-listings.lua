local prefixes = { 'thm', 'lem', 'cor', 'prp', 'cnj', 'exm', 'def', 'exr' }
local opened = {}

function open_files()
  quarto.log.debug("====== opening files")
  for i, prefix in pairs(prefixes) do
    tmp = pandoc.path.filename(os.tmpname())
    opened[prefix] = io.open(tmp .. "_" .. prefix .. "__.yml", "w")
  end
end

function close_files()
  quarto.log.debug("====== closing files")
  for i, prefix in pairs(prefixes) do
    io.close(opened[prefix])
  end
end

function initialize(meta)
  pandoc.system.make_directory("_crossrefs", 1)
  pandoc.system.with_working_directory("_crossrefs", open_files)
  return meta
end

function get_match(s)
  local m
  local i = 0
  repeat
    i = i + 1
    m = string.match(s, prefixes[i].."[-]")
  until i == #prefixes or m
  if m then
    quarto.log.debug("matched "..m.." to "..prefixes[i])
    return prefixes[i]
  else
    return nil
  end
end

function add_listing(el)
  m = get_match(el.attr.identifier)
  if m then
    newguy = { link = "@" .. el.attr.identifier }
    for k, v in pairs(el.attr.attributes) do
      newguy[k] = v
    end
    quarto.log.debug("=========== " .. m)
    quarto.log.debug(newguy)

    io.output(opened[m])
    quarto.log.debug("====== writing " .. newguy["link"])
    h = "- "
    for key, val in pairs(newguy) do
      io.write(h .. key .. ': "' .. val .. '"\n')
      h = "  "
    end
  end
end

return {
  { Meta = initialize },
  { Div = add_listing },
  { Meta = close_files },
}
