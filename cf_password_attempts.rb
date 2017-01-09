def incorrectPasscodeAttempts(passcode, attempts)
    index = attempts.index(passcode)
    index < 0 || index > 9
end
