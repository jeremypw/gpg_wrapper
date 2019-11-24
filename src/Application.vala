/*
 * Copyright (C) 2019      Jeremy Wootten
 *
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 *  Authors:
 *  Jeremy Wootten <jeremywootten@gmail.com>
 *
*/

public class GpgWrapper.App : Gtk.Application {
    public const OptionEntry[] GPG_OPTION_ENTRIES =  {
        { "encrypt", 'e', 0, OptionArg.NONE, out encrypt,
        "Encrypt with default key of current user", null },
        { "decrypt", 'd', 0, OptionArg.NONE, out decrypt,
        "Decrypt with default key of current user", null },
        { null }
    };

    public static bool encrypt = false;
    public static bool decrypt = false;

   construct {
        application_id = "com.github.jeremypw.gpg_wrapper";
        set_option_context_summary (N_("Encrypt or decrypt files with default user gpg key"));
        set_option_context_description (N_("""
Before using this tool, a gpg key must have been set up on the user's key ring. Consult gpg documentation for
instructions. The tool is primarily intended for use as a contractor for the Pantheon Files application and
provides the neccessary contractor files. However, it may be used from the commandline.
"""));

        set_option_context_parameter_string (N_("[FILES]"));
        flags = ApplicationFlags.HANDLES_OPEN;
        Intl.setlocale (LocaleCategory.ALL, "");

        add_main_option_entries (GPG_OPTION_ENTRIES);
    }

    public override void activate () {
        critical (_("No files provided"));
        return;
    }

    public override void open (File[] files, string hint) {
        int successes = 0;
        int fails = 0;

        string action_string = "";
        if (encrypt) {
            if (decrypt) {
                critical ("Inconsistent options provided");
                return;
            } else {
                action_string = _("Encrypting");
            }
        } else if (decrypt) {
            action_string = _("Decrypting");
        } else {
            critical ("No options provided - aborting");
            return;
        }

        message (action_string);

        foreach (File in_file in files) {
            string in_path = in_file.get_path ();
            string out_path;
            string gpg_commandline = "";

            if (decrypt) {
                if (in_path.has_suffix (".gpg")) {
                    out_path = in_path.slice (0, -4);
                }

                out_path = in_path + ".decrypted";

                var out_file = File.new_for_path (out_path);

                if (!out_file.query_exists (null)) {
                    out_path = "'" + out_path + "'"; //Quote in case output contains spaces
                    gpg_commandline = ("gpg -o %s --decrypt ").printf (out_path);
                }
            } else {
                gpg_commandline = "gpg -e -r %s ".printf (Environment.get_user_name ());
            }

            if (gpg_commandline != "") {
                var command = gpg_commandline + "'" + in_path + "'"; //Quote in case input contains spaces

                try {
                    string std_out, std_err;
                    int exit_status;
                    if (Process.spawn_command_line_sync (command, out std_out, out std_err, out exit_status)) {
                        if (exit_status == 0) {
                            message ("SUCCESS");
                            successes++;
                        }
                    }
                } catch (SpawnError e) {
                    warning ("Error spawning %s - %s", command, e.message);
                }
            }
        }

        fails = files.length - successes;

        if (encrypt) {
            ///TRANSLATORS: %i is a placeholder for an integer. It may be moved but not changed or omitted
            message (ngettext (_("%i file encrypted successfully"), _("%i files encrypted successfully"), successes), successes);
            ///TRANSLATORS: %i is a placeholder for an integer. It may be moved but not changed or omitted
            message (ngettext (_("Encryption failed for %i file"), _("Encryption failed for %i files"), fails), fails);
        } else {
            ///TRANSLATORS: %i is a placeholder for an integer. It may be moved but not changed or omitted
            message (ngettext (_("%i file decrypted successfully"), _("%i files decrypted successfully"), successes), successes);
            ///TRANSLATORS: %i is a placeholder for an integer. It may be moved but not changed or omitted
            message (ngettext (_("Decryption failed for %i file"), _("Decryption failed for %i files"), fails), fails);
        }
    }
}

public static int main (string[] args) {
    var application = new GpgWrapper.App ();
    return application.run (args);
}
