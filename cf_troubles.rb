def troubleFiles(files, backups)
    fin = 0
    backups.map do |time|
        to_backup = []

        while fin < files.length && files[fin][0] <= time
            to_backup << files[fin]
            fin += 1
        end
        
        total_size = to_backup.map(&:last).reduce(&:+).to_i
        
        troubles = 0
        
        while fin < files.length && files[fin][0] <= time + total_size
            troubles += 1
            fin += 1
        end
        
        troubles
    end
end

files = [[461618501,3], [461618502,1], [461618504,2], [461618506,5], [461618507,6]]
backups = [461618501, 461618502, 461618504, 461618505, 461618506]

p troubleFiles(files, backups)
