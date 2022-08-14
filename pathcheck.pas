program PathCheck;

{
    Check from a list if the path exists.
    Report to stdout about the status.

    Version 01
}


{$MODE ObjFPC}
{$H+}


uses
    SysUtils;


function GetTempOutput(): string;
begin
    GetTempOutput := '/tmp/pathcheck.log';
end; { function GetTempOutput() }


function GetCurrentDateTimeMicro(): AnsiString;
var 
    dt: TDateTime;
begin
    dt := Now();
    // FormatDateTime: https://www.freepascal.org/docs-html/rtl/sysutils/formatchars.html
    GetCurrentDateTimeMicro := FormatDateTime('yyyy-mm-dd hh:mm:ss.zzz', dt);
end;


function GetPathList(): string;
begin
    GetPathList := ParamStr(0) + '.list';
end; { function GetPathList() }


function GetDirectory(p: AnsiString): AnsiString;
{
    Returns the directory based on the path

    /tmp/file.ext --> /tmp/
}
begin
    Result := Copy(p, 1, LastDelimiter('/', p));
end;


procedure WriteToLog(var f: TextFile; s: AnsiString);
var
    DateTimeLog: AnsiString;
    LogText: AnsiString;
begin
    DateTimeLog := GetCurrentDateTimeMicro();
    LogText := DateTimeLog + ' ' + s;
    writeln(f, LogText);
end; { procedure WriteToLog() }


procedure ProcessLine(var fo: TextFile; line: AnsiString);
{
    Processes a line from the list file.

    Parameters:
        fo: Pointer to the output log file.
        line: A string with a search pattern.
}
var
    rec: TSearchRec;
begin
    if FindFirst(line, faAnyFile-faDirectory, rec) = 0 then
    begin
        repeat
            //writeln(rec.Name);
            WriteToLog(fo, 'template="' + line + '" file_name="' + rec.Name + '" path="' + GetDirectory(line) + rec.Name + '" file_size_bytes=' + IntToStr(rec.Size) + ' status="FOUND"');
        until FindNext(rec) <> 0;
        FindClose(rec);
    end
    else
        WriteToLog(fo, 'template="' + line + '" status="NOT_FOUND"');
end; { procedure ProcessLine() }


procedure ProgInit();
begin
end; { procedure ProgInit() }


procedure ProgRun();
var
    fi: TextFile;
    fo: TextFile;
    line: AnsiString;
    PathOutput: AnsiString;
begin
    //writeln('PATH_CHECK');

    PathOutput := GetTempOutput();
    //writeln('Output file is "' + PathOutput + '"');

    AssignFile(fo, PathOutput);
    {$I-}
    Rewrite(fo);
    {$I+}

    AssignFile(fi, GetPathList());
    Reset(fi);
    while not EOF(fi) do
    begin
        ReadLn(fi, line);
        ProcessLine(fo, line);
    end;
    CloseFile(fi);
    CloseFile(fo);
end; { procedure ProgRun() }


procedure ProgDone();
begin
end; { procedure ProgDone() }


procedure ProgTest();
begin
    writeln(GetDirectory('/tmp/dummy/file.ext'));
end; { procedure ProgTest() }


begin
    ProgInit();
    ProgRun();
    //ProgTest();
    ProgDone();
end. { program main }
