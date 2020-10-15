library MM6chup;

uses
  SysUtils,
  RSSysUtils,
  Hooks in 'Hooks.pas';

begin
  try
    AssertErrorProc:= RSAssertErrorHandler;
    HookAll;
    Randomize;
  except
    ShowException(ExceptObject, ExceptAddr);
  end;
end.