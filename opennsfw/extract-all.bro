module ExtractAllFiles;

export {
        ## Path to save extracted files to
        const path = "/work/images/" &redef;

        ## This table contains a conversion of image mime types to their
        ## corresponding 'normal' file extensions.
        const common_types: table[string] of string = {
                ["image/bmp"] = "bmp",
                ["image/x-windows-bmp"] = "bmp",
                ["image/gif"] = "gif",
                ["image/jpeg"] = "jpg",
                ["image/png"] = "png",
        };
}

event bro_init()
{
    Log::disable_stream(Conn::LOG);
}

event file_sniff(f: fa_file, meta: fa_metadata)
        {
        if ( !meta?$mime_type )
                return;

        if ( !f?$total_bytes || f$total_bytes < 10240)
                return;

        local ftype = "";
        if ( meta$mime_type in common_types )
                ftype = common_types[meta$mime_type];
        else
        return;

        local ftime = strftime("%Y-%m-%d_%H-%M-%S", f$http$ts);
    local fname = fmt("%s-%s-%s-%s.%s", f$http$id$orig_h, f$http$id$resp_h, ftime, f$id, ftype);

        Files::add_analyzer(f, Files::ANALYZER_EXTRACT, [$extract_filename=fname]);
}