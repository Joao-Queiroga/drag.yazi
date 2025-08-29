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

---@return string
local function get_os()
	return (select(1, Command("uname"):stdout(Command.PIPED):output()).stdout or ""):lower()
end

return {
	entry = function()
		local files = selected_files()

		if not #files then
			return
		end

		local cmd

		if get_os():match("^darwin") then
			local quoted_files, file_str = {}, ""
			for _, file in ipairs(files) do
				quoted_files[#quoted_files + 1] = "'" .. file:gsub("'", "'\\''") .. "'"
			end

			file_str = table.concat(quoted_files, " ")

			local bash_cmd = string.format(
				[[
            BASE_TMP_DIR="${TMPDIR:-/tmp}"
            TARGET_DIR="${BASE_TMP_DIR}/yazi-%s"
            [ -d "$TARGET_DIR" ] && rm -rf "$TARGET_DIR"/* || mkdir -p "$TARGET_DIR"
            cp -R %s "$TARGET_DIR" && open "$TARGET_DIR"
            ]],
				os.getenv("YAZI_ID") or "000000",
				file_str
			)
			cmd = Command("bash"):arg({ "-c", bash_cmd })
		else
			cmd = Command("ripdrag"):arg({ "-a", "-x" }):arg(files)
		end

		local child, err = cmd:spawn()
		if not child then
			fail("Spawn `ripdrag` failed with error code %s.", err)
			return
		end
		local output
		output, err = child:wait_with_output()
		if not output then
			fail("Cannot read `ripdrag` output, error code %s", err)
		elseif not output.status.success and output.status.code ~= 131 then
			fail("`ripdrag` exited with error code %s", output.status.code)
		end
	end,
}
