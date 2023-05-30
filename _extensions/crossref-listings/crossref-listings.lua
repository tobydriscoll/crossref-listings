-- listing_contents = pandoc.List()
-- function add_listing(el)
--   if string.match(el.attr.identifier,"exm-") then
--     newguy = { 
--       Link=pandoc.Inlines(pandoc.Str(el.attr.identifier)),
--       Type=pandoc.Inlines(pandoc.Str("sport")),
--       title=pandoc.Inlines(pandoc.Str("football"))
--   }
--     listing_contents:insert(newguy)
--     quarto.log.output("===========")
--     quarto.log.output(el.attr)
--   end
-- end

listing_contents = { }
prefixes = {}
opened = {} 

function open_files()
  quarto.log.debug("====== opening files")
  for i, prefix in pairs(prefixes) do
    tmp = pandoc.path.filename(os.tmpname())
    opened[prefix] = io.open(tmp.."_"..prefix.."__.yml", "w")
  end
end

function close_files()
  quarto.log.debug("====== closing files")
  for i, prefix in pairs(prefixes) do
    io.close(opened[prefix])
  end
end

function find_prefixes(meta)
  prefixes = meta.crossref_listings:map(pandoc.utils.stringify)
  quarto.log.debug("====== prefixes")
  quarto.log.debug(prefixes)
  pandoc.system.make_directory("_crossrefs", 1)
  pandoc.system.with_working_directory("_crossrefs", open_files)
  return meta
end

function get_match(s)
  local m
  local i = 0
  repeat
    i = i+1
    m = string.match(s, prefixes[i].."-")
  until i == #prefixes or m 
  if m then 
    quarto.log.debug("matched "..prefixes[i])
    return prefixes[i]
  else
    return nil 
  end
end

function add_listing(el)
  m = get_match(el.attr.identifier)
  if m then
    newguy = { link="@" .. el.attr.identifier }
    for k,v in pairs(el.attr.attributes) do
      newguy[k] = v 
    end
    quarto.log.debug("=========== "..m)
    quarto.log.debug(newguy)
    if not listing_contents[m] then
      listing_contents[m] = {}
    end
    -- table.insert(listing_contents[m], newguy)
    io.output(opened[m])
    quarto.log.debug("====== writing "..newguy["link"])
    h = "- "
    for key, val in pairs(newguy) do
      io.write(h..key..': "'..val..'"\n')
      h= "  "
    end
end
end

function write_file()
  for prefix, found in pairs(listing_contents) do
    io.output(opened[prefix])
    for i, item in pairs(found) do
      h = "- "
      for key, val in pairs(item) do
        io.write(h..key..': "'..val..'"\n')
        h= "  "
      end
    -- io.write(quarto.json.encode(found))
    end
    io.close(opened[prefix])
  end
end

function write_info(meta)
    pandoc.system.with_working_directory("_crossrefs", write_file)
end

return {
  {Meta = find_prefixes},
  {Div = add_listing},
  -- {Pandoc = write_info},
  {Pandoc = close_files},
}