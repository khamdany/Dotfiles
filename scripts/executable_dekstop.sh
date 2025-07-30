#!/usr/bin/env bash

# Standard directories
USER_DIR="$HOME/.local/share/applications"
SYSTEM_DIR="/usr/share/applications"
DESKTOP_DIRS=("$USER_DIR" "$SYSTEM_DIR")

# --- Helper Functions ---

# Helper function to find, parse, and select .desktop files using fzf.
# It takes fzf arguments as parameters to allow for single or multi-select.
_select_desktop_files() {
    local fzf_options="$@"
    
    # We use an associative array to map the friendly name to the file path.
    declare -A desktop_map
    
    # Find all .desktop files, read their 'Name=' line, and populate the map.
    # The format is 'FilePath:Name=Friendly Name' which we parse with IFS.
    while IFS=':' read -r file_path name_line; do
        if [[ -n "$name_line" ]]; then
            # Extract the value after 'Name='
            local name="${name_line#Name=}"
            desktop_map["$name"]="$file_path"
        fi
    done < <(find "${DESKTOP_DIRS[@]}" -type f -name "*.desktop" -exec grep -H -m1 '^Name=' {} + 2>/dev/null)

    if [[ ${#desktop_map[@]} -eq 0 ]]; then
        echo "No applications with a 'Name=' entry were found." >&2
        return 1
    fi

    # Let the user select from the application names using fzf.
    local selected_names
    selected_names=$(printf '%s\n' "${!desktop_map[@]}" | sort | fzf ${fzf_options})

    # If the user cancelled fzf (ESC), exit gracefully.
    [[ -z "$selected_names" ]] && return 1

    # Output the full path for each selected name.
    while IFS= read -r name; do
        echo "${desktop_map[$name]}"
    done <<< "$selected_names"
}


# --- Menu Actions ---

function edit_desktop() {
    echo "Loading applications to edit..."
    # Call the selector for a single choice.
    local file
    file=$(_select_desktop_files --prompt="Select application to edit: ")
    
    [[ -z "$file" ]] && echo "Cancelled." && return

    # Use 'helix' as the editor, as in the original script.
    helix "$file"
}

function delete_desktop() {
    echo "Loading applications to delete..."
    # Call the selector, allowing multiple choices.
    mapfile -t files < <(_select_desktop_files --multi --prompt="Select applications to DELETE (use TAB): ")

    [[ ${#files[@]} -eq 0 ]] && echo "Cancelled." && return

    echo
    echo "The following files will be PERMANENTLY DELETED:"
    printf -- '- %s\n' "${files[@]}"
    echo

    read -rp "Are you sure you want to delete these files? (y/N): " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        for f in "${files[@]}"; do
            # Add a safety check: only remove files in the user's home directory.
            if [[ "$f" == "$USER_DIR"* ]]; then
                rm -f "$f" && echo "Deleted: $f"
            else
                echo "Skipped (System File): $f"
            fi
        done
        echo "Deletion complete."
    else
        echo "Cancelled."
    fi
}

function create_desktop() {
    echo "--- Create New .desktop File ---"
    read -rp "Application Name: " app_name
    read -rp "Executable command (e.g., /usr/bin/nano): " exec_path
    read -rp "Icon name or path (optional): " icon_path
    read -rp "Categories (e.g., Utility;TextEditor;): " categories

    if [[ -z "$app_name" || -z "$exec_path" ]]; then
        echo "Error: Application Name and Executable cannot be empty."
        return 1
    fi

    # Create a safe filename by replacing spaces with underscores.
    local file_path="$USER_DIR/${app_name// /_}.desktop"

    # Ensure the target directory exists.
    mkdir -p "$USER_DIR"

    # Use a 'here document' to write the file content.
    cat > "$file_path" <<EOF
[Desktop Entry]
Type=Application
Name=$app_name
Exec=$exec_path
Icon=$icon_path
Categories=$categories
Terminal=false
EOF

    chmod +x "$file_path"
    echo -e "\nSuccess! Created: $file_path"
    echo "Opening with helix for any final edits..."
    sleep 1
    helix "$file_path"
}

function show_menu() {
    echo
    echo "=== Desktop File Manager ==="
    echo "1) Edit an application entry"
    echo "2) Delete application entries"
    echo "3) Create a new application entry"
    echo "q) Quit"
    echo "============================"
    read -rp "Select an option: " option

    case "$option" in
        1) edit_desktop ;;
        2) delete_desktop ;;
        3) create_desktop ;;
        q|Q|0) echo "Exiting."; exit 0 ;;
        *) echo "Invalid option. Please try again." ;;
    esac
}


# --- Main Loop ---
while true; do
    show_menu
done
