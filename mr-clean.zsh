#!/bin/zsh

if [ $# -eq 0 ]; then
  echo "Please provide a directory to clean up."
  echo "use -h or --help for more information"
  exit 1
fi

echo "--- Mr Clean is in the dir dir ---"

print_help() {
  echo "Usage: dir-clean-up.sh [directory]"
  echo "Options:"
  echo "--downloads | -dl: Clean up the Downloads directory"
  echo "--desktop | -dt: !!WIP!! Clean up the Desktop directory"
  echo "--undo | -u: Undo the last clean up"
  exit 0
}


organise_downloads() {
  echo "Cleaning up the Downloads directory"

  # Sort files in the Downloads directory into folders based on the creation month
  for file in ~/Downloads/*; do
    sort_files_by_date "$file"
  done

  # Sort folders in the Downloads directory into folders based on the creation month
  for folder in ~/Downloads/*; do
    sort_folders_by_date "$folder"
  done

  # Move folders for files older than 6 months to an archive folder
  for folder in ~/Downloads/*; do
    archive_old_files "$folder"
  done

  echo "Last visited by Mr. Clean on $(date)" > ~/Downloads/mr_clean_was_here.txt
}


# Sort files and folders
sort_files_by_date() {
  file=$1
  file_name=$(basename "$file")

  if [ -f "$file" ]; then
    sort_by_date "$file"
  fi
}

sort_folders_by_date() {
  folder=$1
  folder_name=$(basename "$folder")

  if [ -d "$folder" ]; then
    if [[ ! $folder_name =~ ^[0-9]{4}-[0-9]{2}$ && $folder_name != "_archive" ]]; then
      sort_by_date "$folder"
    fi
  fi
}

sort_by_date() {
  entity=$1
  entity_name=$(basename "$entity")

  # get the creation time in seconds
  entity_creation_time=$(stat -f "%B" "$entity")

  # convert the creation time to a human readable format
  entity_creation_month=$(date -r "$entity_creation_time" "+%Y-%m")
  
  echo "Moving $entity_name to ~/Downloads/$entity_creation_month"
  # create a directory with the creation month if it doesn't exist
  if [ ! -d ~/Downloads/$entity_creation_month ]; then
    mkdir ~/Downloads/$entity_creation_month
  fi
  
  mv "$entity" ~/Downloads/$entity_creation_month
}

archive_old_files() {
  
  folder=$1
  folder_name=$(basename "$folder")
  
  if [[ $folder_name =~ ^[0-9]{4}-[0-9]{2}$ ]]; then
    folder_creation_month=$(date -j -f "%Y-%m" "$folder_name" "+%s")
    current_month=$(date "+%s")
    six_months_ago=$(date -v-6m "+%s")

    if [ $folder_creation_month -lt $six_months_ago ]; then
      echo "Moving $folder_name to ~/Downloads/_archive"
      mv "$folder" ~/Downloads/_archive
    fi
  fi
}

# undo organise_downloads
undo_organise_downloads() {
  echo "Undoing the last clean up in the Downloads directory"

  # Move all folders from the _archive folder back to the Downloads directory
  undo_archive_old_files

  # Move all files from the month folders back to the Downloads directory
  for folder in ~/Downloads/*; do
    undo_sort_files_by_date "$folder"
  done
}

undo_archive_old_files() {
  if [ -d ~/Downloads/_archive ]; then
    echo "Moving folders from ~/Downloads/_archive back to ~/Downloads"
    
    if [ "$(ls -A ~/Downloads/_archive)" ]; then
      for folder in ~/Downloads/_archive/*; do
        mv "$folder" ~/Downloads
      done
    fi
    rm -r ~/Downloads/_archive
  fi
}

undo_sort_files_by_date() {
  file=$1
  
   if [ -d "$folder" ]; then

      folder_name=$(basename "$folder")

      if [[ $folder_name =~ ^[0-9]{4}-[0-9]{2}$ ]]; then
        echo "Moving files from $folder back to ~/Downloads"
        # Use the dotglob shell option to include hidden files
        shopt -s dotglob
        for file in "$folder"/*; do
          mv "$file" ~/Downloads
        done
        # Disable the dotglob shell option
        shopt -u dotglob
        rmdir "$folder"
      fi
    fi
}

empty_trash() {
  echo "Emptying the Bin..."
  rm -rf ~/.Trash/*
  echo "Bin emptied."
}


case $1 in
  "--help" | "-h" )
    print_help ;;
  "--downloads" | "-dl" )
    organise_downloads ;;
  "--desktop" | "-dt" )
    organise_desktop ;;
  "--trash" | "-tr" )
    empty_trash ;;
  "--undo" | "-u" )
    case $2 in
      "--downloads" | "-dl" )
        undo_organise_downloads ;;
      "--desktop" | "-dt" )
        undo_organise_desktop ;;
      * )
        echo "Invalid option. Please provide a valid option to undo."
        exit 1 ;;
    esac ;;
esac
