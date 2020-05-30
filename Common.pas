unit Common;

interface

uses
  Windows, Messages, SysUtils, Classes, IniFiles, RSSysUtils, RSQ;

procedure LoadIni;
function GetOptions: ptr; stdcall;

type
  TSaveSlotFile = array[0..279] of char;
  TSaveSlotFiles = array[0..19] of TSaveSlotFile;
  PSaveSlotFiles = ^TSaveSlotFiles;

const
  _Paused = pint($4D5184);
  _UsingBook = pint($4D45CC);
  _CurrentScreen = pint($4BCDD8);
  _MainMenuCode = pint($5F811C);
  _FlipOnExit = pint($4C0E1C);
  _LoudMusic = pint($4C0E20);
  _Lucida_fnt = pptr($55BDB4);
  _CurrentMember = pint($4D50E8);
  _CurrentCharScreen = pint($4D4714);
  _NeedRedraw = pint($52D29C);
  _TextBuffer1 = pchar($55CDE0);
  _TextBuffer2 = pchar($55D5B0);
  _ActionQueue = ptr($4D5F48);
  _PartyMembers = $944C64;
  _TurnBased = pbool($908E30);
  _SaveSlot = pint($6A5F6C);
  _SaveScroll = pint($6A5F68);
  _SaveSlotsFiles = PSaveSlotFiles($5F883C);
  _SaveSlotsCount = pint($5FB9B4);
  _TurnBasedDelays = $4C6CA8;
  _ItemsTxt = $560C14;
  _ItemsTxtOff_Size = $30;
  _MainWindow = puint($61076C);
  _Party_X = pint($908C98);
  _Party_Y = pint($908C9C);
  _Party_Z = pint($908CA0);
  _Party_Direction = pint($908CA4);
  _Party_Angle = pint($908CA8);
  _ScreenW = pint($4CA71C);
  _TimeDelta = pint($4D519C);
  _Flying = pint($908CE8);
  _MapMonsters = $56F478;

  _PauseTime: procedure(a1: int = 0; a2: int = 0; this: int = $4D5180) = ptr($420DB0);
  _SaveGameToSlot: procedure(n1,n2, slot:int) = ptr($44FEF0);
  _DoSaveGame: procedure(n1,unk, autosave: int) = ptr($44F320);
  _DoLoadGame: procedure(n1,n2, slot: int) = ptr($44EE50);
  _LoadGameStats: procedure(n1,n2, slot:int) = ptr($44EE50);
  _FindActiveMember: function(n1: int = 0; n2: int = 0; this: int = $908C70):int = ptr($487780);
  _ShowStatusText: function(n1, seconds: int; Text: PChar): int = ptr($442BD0);
  //_StrWidth: function(n1:int; str:PChar; fnt:ptr):int = ptr($442DD0);
  _OpenInventory_part: function(a1: int = 0; a2: int = 0; screen: int = 7):int = ptr($41FA50);
  _OpenInventory_result = pint($4D50CC);
  _access: function(fileName: PChar; unk: int = 0): int cdecl = ptr($4B885E);
  _malloc: function(size:int):ptr cdecl = ptr($4AE753);
  _PermAlloc: function(n1,n2: int; allocator: ptr; name: PChar; size, unk: int):ptr = ptr($421390);
  _PermAllocator = ptr($5FCB50);
  _ProcessActions: procedure = ptr($42ADA0);
  _LoadMapTrack: procedure = ptr($454F90);
  _PlaySound = $48EB40;
  _PlaySoundStruct = $9CF598;

  _Chest_CanPlaceItem: function(n1, itemType, pos, chest: int): BOOL = ptr($41DE90);
  _Chest_PlaceItem: procedure(n1, itemIndex, pos, chest: int) = ptr($41E210);
  _ChestWidth = $4BD18C;
  _ChestHeight = $4BD1AC;

  _Character_GetWeaponDelay: function(n1, n2: int; this:ptr; ranged: LongBool):int = ptr($481A80);
  _Character_SetDelay: procedure(n1, n2: int; this: ptr; delay: int) = ptr($482C80);
  _Character_IsAlive: function(a1,a2, member:ptr):Bool = ptr($4876E0);
  _Character_CalcSpecialBonusByItems: function(n1,n2:int; member:ptr; SpecialEnchantment:int):int = ptr($482E00);
  _Character_Recover: function(n1, n2: int; this: ptr; time: int): Bool = ptr($482BB0);

  _CharOff_ItemMainHand = $142C;
  _CharOff_Items = $128;
  _CharOff_Recover = $137C;
  _CharOff_SpellPoints = $1418;
  _CharOff_Size = $161C;

  _ItemOff_Size = $1C;

  _MonOff_X = $7E;
  _MonOff_Y = $80;
  _MonOff_Z = $82;
  _MonOff_vx = $84;
  _MonOff_vy = $86;
  _MonOff_BodyRadius = $78;
  _MonOff_Size = $224;

const
  SWrong: string = 'this is not a valid mm6.exe file';

type
  TOptions = packed record
    Size: int;
    MaxMLookAngle: int;                // 4
    MouseLook: LongBool;               // 8
    MouseLookUseAltMode: LongBool;     // 12
    CapsLockToggleMouseLook: LongBool; // 16
    MouseFly: LongBool;                // 20
    MouseWheelFly: LongBool;           // 24
    MouseLookTempKey: int;             // 28
    MouseLookChangeKey: int;           // 32
    InventoryKey: int;                 // 36
    CharScreenKey: int;                // 40
    DoubleSpeedKey: int;               // 44
    QuickLoadKey: int;                 // 48
    AutorunKey: int;                   // 52
  end;

var
  Options: TOptions = (
    Size: SizeOf(TOptions);
    MaxMLookAngle: 180;
  );

var
  QuickSavesCount, QuickSaveKey, MusicLoopsCount, IncreaseRecoveryRateStrength,
  HorsemanSpeakTime, BoatmanSpeakTime, BlasterRecovery: int;

  MLookSpeed, MLookSpeed2: TPoint;

  TurnSpeedNormal, TurnSpeedDouble: single;

  RecoveryTimeInfo, GameSavedText, PlayerNotActive, SDoubleSpeed, SNormalSpeed,
  QuickSaveName, QuickSaveDigitSpace: string;

  CapsLockToggleRun, NoDeathMovie, AlwaysRun, NoCD, FixWalk, FixCompat,
  FreeTabInInventory, FixDualWeaponsRecovery, PlayMP3, ReputationNumber,
  ProgressiveDaggerTrippleDamage, UseMM6text, FixChests, DataFiles,
  AlwaysStrafe, StandardStrafe, MouseLookChanged, FixStarburst,
  FixInfiniteScrolls, FixInactivePlayersActing: Boolean;

  MappedKeys, MappedKeysBack: array[0..255] of Byte;

implementation

procedure LoadIni;
var
  ini, iniOverride: TIniFile;
  sect: string;

  function ReadString(const key, default: string): string;
  begin
    if iniOverride <> nil then
    begin
      Result:= iniOverride.ReadString(sect, key, #13);
      if Result <> #13 then
        exit;
    end;
    Result:= ini.ReadString(sect, key, #13);
    if Result = #13 then
    begin
      ini.WriteString(sect, key, default);
      Result:= default;
    end;
  end;

  function ReadInteger(const key: string; default: int): int;
  begin
    if iniOverride <> nil then
    begin
      Result:= iniOverride.ReadInteger(sect, key, 0);
      if (Result <> 0) or (iniOverride.ReadInteger(sect, key, 1) = 0) then
        exit;
    end;
    Result:= ini.ReadInteger(sect, key, 0);
    if (Result = 0) and (ini.ReadInteger(sect, key, 1) <> 0) then
    begin
      ini.WriteInteger(sect, key, default);
      Result:= default;
    end;
  end;

  function ReadBool(const key: string; default: Boolean): Boolean;
  begin
    Result := ReadInteger(key, Ord(Default)) <> 0;
  end;

var
  i, j:int;
begin
  iniOverride:= nil;
  ini:= TIniFile.Create(AppPath + 'mm6.ini');
  with Options do
    try
      sect:= 'Settings';
      _FlipOnExit^:= ReadInteger('FlipOnExit', 0);
      _LoudMusic^:= ReadInteger('LoudMusic', 0);
      AlwaysRun:= ReadBool('AlwaysRun', true);
      CapsLockToggleRun:= ReadBool('CapsLockToggleRun', false);

      QuickSavesCount:= ReadInteger('QuickSavesCount', 2);

      i:= ini.ReadInteger(sect, 'QuickSaveKey', 11) + VK_F1 - 1;
      if (i < VK_F1) or (i > VK_F24) then
        i:= VK_F11;
      QuickSaveKey:= ReadInteger('QuickSavesKey', i);
      if (QuickSaveKey < 0) or (QuickSaveKey > 255) then
        QuickSaveKey:= VK_F11;
      QuickLoadKey:= ReadInteger('QuickLoadKey', 0);

      ini.DeleteKey(sect, 'QuickSaveKey');
      ini.DeleteKey(sect, 'QuickSaveSlot1');
      ini.DeleteKey(sect, 'QuickSaveSlot2');
      ini.DeleteKey(sect, 'QuickSaveName');

      NoDeathMovie:= ReadBool('NoDeathMovie', false);
      NoCD:= ReadBool('NoCD', true);
      FixWalk:= ReadBool('FixWalkSound', true);
      FixCompat:= ReadBool('FixCompatibility', true);
      InventoryKey:= ReadInteger('InventoryKey', ord('I'));
      CharScreenKey:= ReadInteger('ToggleCharacterScreenKey', 192);
      FreeTabInInventory:= ReadBool('FreeTabInInventory', true);
      FixDualWeaponsRecovery:= ReadBool('FixDualWeaponsRecovery', true);
      PlayMP3:= ReadBool('PlayMP3', false);
      MusicLoopsCount:= ReadInteger('MusicLoopsCount', 1);
      ReputationNumber:= ReadBool('ReputationNumber', true);
      DoubleSpeedKey:= ReadInteger('DoubleSpeedKey', VK_F2);
      TurnSpeedNormal:= ReadInteger('TurnSpeedNormal', 100)/100;
      TurnSpeedDouble:= ReadInteger('TurnSpeedDouble', 120)/200;
      IncreaseRecoveryRateStrength:= ReadInteger('IncreaseRecoveryRateStrength', 10);
      ProgressiveDaggerTrippleDamage:= ReadBool('ProgressiveDaggerTrippleDamage', true);
      FixChests:= ReadBool('FixChests', true);
      BlasterRecovery:= ReadInteger('BlasterRecovery', 5);
      DataFiles:= ReadBool('DataFiles', true);
      MouseLook:= ReadBool('MouseLook', false);
      MLookSpeed.X:= ReadInteger('MouseSensitivityX', 35);
      MLookSpeed.Y:= ReadInteger('MouseSensitivityY', 35);
      MLookSpeed2.X:= ReadInteger('MouseSensitivityAltModeX', 75);
      MLookSpeed2.Y:= ReadInteger('MouseSensitivityAltModeY', 75);
      MouseLookChangeKey:= ReadInteger('MouseLookChangeKey', VK_MBUTTON);
      MouseLookTempKey:= ReadInteger('MouseLookTempKey', 0);
      CapsLockToggleMouseLook:= ReadBool('CapsLockToggleMouseLook', true);
      MouseLookUseAltMode:= ReadBool('MouseLookUseAltMode', false);
      MouseFly:= ReadBool('MouseLookFly', true);
      MouseWheelFly:= ReadBool('MouseWheelFly', true);
      AlwaysStrafe:= ReadBool('AlwaysStrafe', false);
      StandardStrafe:= ini.ReadBool(sect, 'StandardStrafe', false);
      AutorunKey:= ReadInteger('AutorunKey', VK_F3);
      FixStarburst:= ini.ReadBool(sect, 'FixStarburst', true);
      FixInfiniteScrolls:= ini.ReadBool(sect, 'FixInfiniteScrolls', true);
      FixInactivePlayersActing:= ini.ReadBool(sect, 'FixInactivePlayersActing', true);
      if FileExists(AppPath + 'mm6text.dll') then
        UseMM6text:= ReadBool('UseMM6textDll', true);

      for i:=1 to 255 do
        MappedKeysBack[i]:= i;
      
      for i:=1 to 255 do
      begin
        j:= ini.ReadInteger('Controls', 'Key'+IntToStr(i), i);
        MappedKeys[i]:= j;
        if j <> i then
          MappedKeysBack[j]:= i;
      end;

      iniOverride:= ini;
      ini:= TIniFile.Create(AppPath+'mm6lang.ini');

      QuickSaveName:= ReadString('QuickSavesName', 'Quicksave');
      if ReadBool('SpaceBeforeQuicksaveDigit', false) then
        QuickSaveDigitSpace:= ' ';
      RecoveryTimeInfo:= #10#10 + ReadString('RecoveryTimeInfo', 'Recovery time: %d');
      GameSavedText:= ReadString('GameSavedText', 'Game Saved!');
      PlayerNotActive:= ReadString('PlayerNotActive', 'That player in not active');
      SDoubleSpeed:= ReadString('DoubleSpeed', 'Double Speed');
      SNormalSpeed:= ReadString('NormalSpeed', 'Normal Speed');
      HorsemanSpeakTime:= ReadInteger('HorsemanSpeakTime', 1500);
      BoatmanSpeakTime:= ReadInteger('BoatmanSpeakTime', 2500);
    finally
      ini.Free;
      iniOverride.Free;
    end;
end;

function GetOptions: ptr; stdcall;
begin
  Result:= @options;
end;

end.
