local file, GM = file, GM

--- "Find" function, this will replace the stock file.Find implemented by Garry.
-- Use this as a replacement to the standard file.find. This enables the use of file.Find in one liners.
-- @author Radon
-- @param typeof What to return, files, or directories. Defaults to directories if not passed "file".
-- @param ... Other parameters, array of passed params which will be used in file.Find, see official Garrys Mod documentation.
--
function GM.wrappers:Find(typeof, ...)

	local typeof = typeof
	local files, dirs = {}, {}

	files, dirs = file.Find(...)

	if typeof == "file" then
		return files
	else
		return dirs
	end
end