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
        { "", 0, 0, OptionArg.STRING_ARRAY, ref remaining,
                        null, N_("[PATH…]") },
        { null }
    };


    public static bool encrypt = false;
    public static bool decrypt = false;

   construct {
        application_id = "com.github.jeremypw.gpg_wrapper";
        flags |= ApplicationFlags.HANDLES_COMMAND_LINE;
        Intl.setlocale (LocaleCategory.ALL, "");
    }

    /* The array that holds the file commandline arguments
       needs some boilerplate so its size gets updated. */
    [CCode (array_length = false, array_null_terminated = true)]
    public static string[]? remaining = null;

    public override int command_line (ApplicationCommandLine cmd) {
        var context = new OptionContext (_("Encrypt or Decrypt files using gpg"));
        context.add_main_entries (GPG_OPTION_ENTRIES, null);
        context.add_group (Gtk.get_option_group (true));

        string[] args = cmd.get_arguments ();

        try {
            context.parse_strv (ref args);
        } catch(Error e) {
            print (e.message + "\n");
            return Posix.EXIT_FAILURE;
        }

        if (encrypt) {
            if (decrypt) {
                warning ("Inconsistent options provided");
            } else {
                warning ("Encrypting");
            }
        } else if (decrypt) {
            warning ("Decrypting");
        } else {
            warning ("No options provided");
            return Posix.EXIT_FAILURE;
        }

        if (remaining == null) {
            warning ("no files provided");
            return Posix.EXIT_FAILURE;
        }

        foreach (string s in remaining) {
            warning ("File %s", s);
        }

        return Posix.EXIT_SUCCESS;
    }
}

public static int main (string[] args) {
    var application = new GpgWrapper.App ();
    return application.run (args);
}
