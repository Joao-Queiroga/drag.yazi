---@param s string
local function fail(s, ...)
	ya.notify({ title = "ripdrag", content = string.format(s, ...), timeout = 3, level = "error" })
end

---@return string[]
local selected_files = ya.sync(function()
	local tab, paths = cx.active, {}
	for _, u in pairs(tab.selected) do
		paths[#paths + 1] = tostring(u)
	end
	if #paths == 0 and tab.current.hovered then
		paths[1] = tostring(tab.current.hovered.url)
	end
	return paths
end)

return {
	entry = function()
		local files = selected_files()
		local cmd = Command("ripdrag"):arg({ "-a", "-x" }):arg(files)
		local child, err = cmd:spawn()
		if not child then
			fail("Spawn `ripdrag` failed with error code %s.", err)
			return
		end
		local output, err = child:wait_with_output()
		if not output then
			fail("Cannot read `ripdrag` output, error code %s", err)
		elseif not output.status.success and output.status.code ~= 131 then
			fail("`ripdrag` exited with error code %s", output.status.code)
		end
	end,
}
