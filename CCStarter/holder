-- Table to store user credentials
local users = {}

-- Standard programs directory
local programsDir = "/programs"

-- Function to initialize the program and create the admin user
local function initialize()
  print("Welcome to the program initialization!")
  print("Enter a new username for the admin:")
  local adminUsername = read()
  print("Enter a new password for the admin:")
  local adminPassword = read()

  users[1] = { username = adminUsername, password = adminPassword }
  fs.makeDir(adminUsername)
  print("Admin profile created successfully!")
end

-- Function to create a new user
local function createUser()
  print("Creating a new user.")
  print("Enter username:")
  local username = read()
  print("Enter password:")
  local password = read()

  table.insert(users, { username = username, password = password })
  fs.makeDir(username)
  print("User created successfully!")
end

-- Function to log in
local function login()
  print("Enter username:")
  local username = read()
  print("Enter password:")
  local password = read()

  for _, user in ipairs(users) do
    if user.username == username and user.password == password then
      print("Login successful!")
      return user
    end
  end

  print("Invalid username or password.")
end

-- Function to copy programs directory to user's folder as a subdirectory
local function copyProgramsDir(userDir)
  if not fs.exists(userDir) then
    print("User directory does not exist.")
    return
  end

  if not fs.exists(programsDir) then
    print("Standard programs directory does not exist.")
    return
  end

  local userProgramsDir = userDir .. "/user_programs"
  fs.makeDir(userProgramsDir)

  for _, file in ipairs(fs.list(programsDir)) do
    fs.copy(programsDir .. "/" .. file, userProgramsDir .. "/" .. file)
  end

  print("Programs directory copied successfully.")
end

-- Function to handle the main program
local function mainProgram(user)
  while true do
    print("Welcome, " .. user.username .. "! Type 'logout' to log out.")
    local input = read()

    if input == "logout" then
      return true
    else
      -- Add your main program functionality here for the user's directory.
      print("Command not recognized. Type 'logout' to log out.")
    end
  end
end

-- Check if the program has been initialized already
local initializedFile = "/initialized"
if not fs.exists(initializedFile) then
  initialize()
  fs.open(initializedFile, "w").close()  -- Create the 'initialized' file to mark initialization
end

-- Main loop
while true do
  print("Choose an option:")
  print("1. Create User")
  print("2. Login")
  local option = read()

  if option == "1" then
    createUser()
  elseif option == "2" then
    local user = login()
    if user then
      local userDir = "/" .. user.username
      copyProgramsDir(userDir)
      local logout = mainProgram(user)
      if logout then
        -- Return to the login/create user screen
        print("Logged out. Returning to login screen.")
      end
    end
  else
    print("Invalid option. Try again.")
  end
end
