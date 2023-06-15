#!/bin/bash
directory="/home/ii"
collage_file="/home/ii/ii.png"
images=()

# Function to check for new image files
check_for_new_images() {
        local new_images=()
        # Iterate over the files in the directory
        for file in "$directory"/*; do
                # Check if the file is an image and not already in the array
                if [[ -f "$file" && $(file -b --mime-type "$file") =~ ^image/ && ! " ${images[@]} " =~ " $file " ]]; then
     
                        new_images+=("$file")
                fi
        done
        # If new images were found, add them to the main array
        if [[ ${#new_images[@]} -gt 0 ]]; then
                images+=("${new_images[@]}")
                echo "New image(s) added:"
                printf '%s\n' "${new_images[@]}"
                
                convert +append $collage_file "${images[-1]}" $collage_file
                
                #ASCII stuff 
                jp2a --output=ii.txt --width=180 ii.png
                convert -font "Courier" -pointsize 12 -background black -fill white -size 1920x1080  -gravity center TEXT:ii.txt bg/ii-text.png
                #Throws errors when using ssh 
                gsettings set org.gnome.desktop.background picture-uri file:////home/ii/bg/ii-txt.png

        fi
}

check_for_new_images
# Create an infinite loop to monitor new activity
while true; do
        sleep 5
        check_for_new_images
done
