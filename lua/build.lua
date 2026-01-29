local terminal = require("terminal")

local M = {}

-- Helper to save and run command
local function save_and_run(cmd)
  vim.cmd("w")
  terminal.run(cmd)
end

-- Helper to prompt for input and run command
local function prompt_and_run(prompt_text, command_template)
  local input = vim.fn.input(prompt_text)
  if input ~= "" then
    terminal.run(string.format(command_template, input))
  end
end

-- .NET Build Commands
function M.dotnet_build()
  save_and_run("dotnet build")
end

function M.dotnet_run()
  save_and_run("dotnet run")
end

function M.dotnet_build_and_run()
  save_and_run("dotnet build && dotnet run")
end

function M.dotnet_test()
  terminal.run("dotnet test")
end

function M.dotnet_clean_build()
  terminal.run("dotnet clean && dotnet build")
end

-- .NET Project Creation
function M.new_console()
  prompt_and_run("Console project name: ", "dotnet new console -n %s")
end

function M.new_classlib()
  prompt_and_run("Library name: ", "dotnet new classlib -n %s")
end

function M.new_webapi()
  prompt_and_run("API name: ", "dotnet new webapi -n %s")
end

function M.new_class()
  prompt_and_run("Class name: ", "dotnet new class -n %s")
end

function M.new_interface()
  prompt_and_run("Interface name: ", "dotnet new interface -n %s")
end

function M.new_solution()
  prompt_and_run("Solution name: ", "dotnet new sln -n %s")
end

function M.add_package()
  prompt_and_run("Package name: ", "dotnet add package %s")
end

function M.add_project_to_sln()
  local project = vim.fn.input("Project path (.csproj): ")
  if project ~= "" then
    terminal.run("dotnet sln add " .. project)
  end
end

-- Rust Build Commands
function M.cargo_run()
  save_and_run("cargo run")
end

function M.cargo_build()
  save_and_run("cargo build")
end

function M.cargo_test()
  terminal.run("cargo test")
end

function M.cargo_check()
  terminal.run("cargo check")
end

function M.cargo_clippy()
  terminal.run("cargo clippy")
end

function M.cargo_clean()
  terminal.run("cargo clean")
end

function M.cargo_build_release()
  terminal.run("cargo build --release")
end

function M.cargo_run_release()
  terminal.run("cargo run --release")
end

function M.cargo_format_file()
  vim.cmd("!rustfmt %")
  vim.cmd("e")
end

-- Rust Project Creation
function M.cargo_new_bin()
  prompt_and_run("Binary project name: ", "cargo new %s")
end

function M.cargo_new_lib()
  prompt_and_run("Library name: ", "cargo new --lib %s")
end

function M.open_cargo_toml()
  vim.cmd("e Cargo.toml")
end

return M
