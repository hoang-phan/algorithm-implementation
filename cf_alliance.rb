def incrementalBackups(lastBackupTime, changes)
    changes,select do |(time, change)|
        time > lastBackupTime
    end.map(&:last).uniq.sort
end

changes = [[461620203, 1], 
           [461620204, 2], 
           [461620205, 6],
           [461620206, 5], 
           [461620207, 3], 
           [461620207, 5], 
           [461620208, 1]]
lastBackupTime = 461620205

p incrementalBackups(lastBackupTime, changes)
