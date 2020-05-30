unit Hooks;

interface

uses
  Windows, RSSysUtils, Common, RSCodeHook;

procedure HookAll;

implementation

//----- Switch to 16 bit color when going windowed

// var
//   AutoColor16Std: ptr;

procedure AutoColor16Proc;
var
  mode: TDevMode;
begin
  if (GetDeviceCaps(GetDC(0), BITSPIXEL) <> 16) or (GetDeviceCaps(GetDC(0), PLANES) <> 1) then
    with mode do
    begin
      dmSize:= SizeOf(mode);
      dmBitsPerPel:= 16;
      dmFields:= DM_BITSPERPEL;
      RSWin32Check(ChangeDisplaySettings(mode, CDS_FULLSCREEN) = DISP_CHANGE_SUCCESSFUL);
      // ShowMessage(inttostr(Options.QuickLoadKey);
      // ShowMessage(inttostr(ChangeDisplaySettings(mode, CDS_FULLSCREEN)));
      // ShowMessage(inttostr(DISP_CHANGE_SUCCESSFUL));
    end;
end;

procedure AutoColor16Hook;
asm
  call AutoColor16Proc
  mov ecx, $1B
end;

//----- HooksList

var
  HooksList: array[1..3] of TRSHookInfo = (
    (p: $43F8AB; t: RShtNop; size: $26), // Switch to 16 bit color when going windowed
    (p: $45A8B1; newp: @AutoColor16Hook; t: RShtCall), // Switch to 16 bit color when going windowed
    // (p: $440268; t: RShtNop; size: 4), // bypass the "Ran once" check so that the opening movie can be skipped at the first time
    ()
  );

procedure HookAll;

begin
  Assert(RSCheckHooks(HooksList), SWrong);
  RSApplyHooks(HooksList);
end;

end.
