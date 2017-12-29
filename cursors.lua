local module = {}
local cursors = {}
module.path = os.getenv('HOME') .. '/.microinfo'

function debug(log)
    messenger:Message(log)
end

function set_cursor_pos()
        --local pos = cursors[view.Buf.AbsPath]
        if pos == nil then return end
        view.Cursor.Y = tonumber(pos)
end

function load_cursors(view)
        cursors = {}
        local f = io.open(module.path)
        if f == nil then return end
        for line in f:lines() do
                for k, v in string.gmatch(line, '(.+)%s(%d+)') do
                        cursors[k] = v
                end
        end
        f:close()
        if cursors[view.Buf.AbsPath] == nil then return end
        local pos = cursors[view.Buf.AbsPath]
        view.Cursor.Y = tonumber(pos)

end

function onViewOpen(view)
    return onOpenFile(view)
end

function onOpenFile(view)
    load_cursors(view)
end

function store_cursors(view)
    cursors[view.Buf.AbsPath] = view.Cursor.Loc.Y
    local f = io.open(module.path, 'w+')
    if f == nil then return end
    local a = {}
    for k in pairs(cursors) do
	table.insert(a, k)
    end
    table.sort(a)
    for i,k in ipairs(a) do
	f:write(string.format('%s %d\n', k, cursors[k]))
    end
    f:close()
end

function onQuit(view)
   store_cursors(view)
end

function onSave(view)
    --store_cursors(view)
end

--MakeCommand("init", "cursors.load_cursors", 0)
