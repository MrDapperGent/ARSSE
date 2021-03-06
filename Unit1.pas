{**********************************************************************}
{                                                                      }
{       Advanced Remote Soldat Server Enchanter                        }
{         for SOLDAT                                                   }
{                                                                      }
{       (based on the Soldat Admin source by Michal Marcinkowski)      }
{                                                                      }
{       Copyright (c) 2005-2008 Hars�nyi L�szl� (a.k.a. KeFear)        }
{       Copyright (c) 2007-2011 Gregor A. Cieslak (a.k.a. Shoozza)     }
{       All rights reserved                                            }
{                                                                      }
{       NOT free to distribute or modify                               }
{                                                                      }
{**********************************************************************}

unit Unit1;

interface

uses
  // System libs
  Windows, SysUtils, IniFiles, Dialogs, Graphics, Clipbrd, StrUtils, DateUtils,
  Variants, AppEvnts, Menus, ExtCtrls, StdCtrls, Buttons, ComCtrls, Controls,
  Classes, Messages, Forms, ShellAPI, MMSystem,

  // network libs
  IdComponent, IdTCPConnection, IdTCPClient, IdIRC, IdCoder, IdCoder3to4,
  IdCoderUUE, IdBaseComponent,

  // other libs
  ZAPIBalloon, GIFImage, Hotkey,

  // arsse units
  Mutex, UpdateThread, FlagDB, SearchForm, Refreshx, VersionInfo;

const
  SC_AlwaysOnTopMenuItem = WM_USER + $101;

  MAX_PLAYERS = 32;
  MAX_TEAMS = 5;

  MAX_BOTS = 50;
  MAX_MAPS = 100;
  MAX_LINES = 30;
  MAX_TIMER = 100;

  UM_NOTIFYICON = WM_USER + 124;
  WM_MYMEMO_ENTER = WM_USER + 500;
  WM_UPDATE_COMPLETE = WM_APP + 6315;  // Just a magic number

  MYTRAYICONID = 0;

  CLIENTWIDTH = 722;
  CLIENTHEIGHT = 605;

  EVENTCOUNT = 17;
  EVENTGLOBAL = 6;

  // for playerlist columns
  TEAM_ALPHA = 1;
  TEAM_BETA = 2;
  TEAM_CHARLIE = 3;
  TEAM_DELTA = 4;
  TEAM_SPECTATOR = 5;

  TEAMS_COUNT = 5;

  COLUMN_ID = 0;
  COLUMN_NAME = 1;
  COLUMN_TAGID = 2;
  COLUMN_KILLS = 3;
  COLUMN_CAPS = 4;
  COLUMN_DEATHS = 5;
  COLUMN_RATIO = 6;
  COLUMN_PING = 7;
  COLUMN_TEAM = 8;
  COLUMN_IP = 9;
  COLUMN_NUM = COLUMN_IP;

  COLUMN_TAGID_WIDTH = 102;
  COLUMN_CAPS_WIDTH = 40;

  ITEM_NAME = 0;
  ITEM_HWID = 1;
  ITEM_KILLS = 2;
  ITEM_CAPS = 3;
  ITEM_DEATHS = 4;
  ITEM_RATIO = 5;
  ITEM_PING = 6;
  ITEM_TEAM = 7;
  ITEM_IP = 8;

type
  TForm1 = class(TForm)
    ServerTab: TTabControl;
    AddServer: TButton;
    RemoveServer: TButton;
    ServerName: TEdit;
    PageControl: TPageControl;
    ServerConsole: TTabSheet;
    BotConsole: TTabSheet;
    Label1: TLabel;
    Label6: TLabel;
    AvgPing: TLabel;
    Label7: TLabel;
    TotalScore: TLabel;
    Label8: TLabel;
    TotalDeaths: TLabel;
    Cmd: TComboBox;
    InfoBox: TGroupBox;
    GameMode: TLabel;
    TimeLeft: TLabel;
    Limit: TLabel;
    MapName: TLabel;
    Time: TLabel;
    TimeLabel: TLabel;
    MapNameLabel: TLabel;
    TimeLeftLabel: TLabel;
    LimitLabel: TLabel;
    GameModeLabel: TLabel;
    PlayerCountLabel: TLabel;
    PlayerCount: TLabel;
    PlayerList: TListView;
    Memo: TRichEdit;
    Panel1: TPanel;
    Timer: TTimer;
    PlayerPopup: TPopupMenu;
    Kick1: TMenuItem;
    Ban1: TMenuItem;
    Name1: TMenuItem;
    IP1: TMenuItem;
    Admin1: TMenuItem;
    Add1: TMenuItem;
    Remove1: TMenuItem;
    Movetoteam1: TMenuItem;
    MoveToAlpha1: TMenuItem;
    MoveToBravo1: TMenuItem;
    MoveToCharlie1: TMenuItem;
    MoveToDelta1: TMenuItem;
    Spectator1: TMenuItem;
    N1: TMenuItem;
    Copytoclipboard1: TMenuItem;
    PlayerName1: TMenuItem;
    PlayerIP1: TMenuItem;
    RefreshTimer: TTimer;
    TimerLeft: TTimer;
    PopupMenu1: TPopupMenu;
    Restore1: TMenuItem;
    Exit1: TMenuItem;
    AutoSay: TTimer;
    IdEncoderUUE1: TIdEncoderUUE;
    IdDecoderUUE1: TIdDecoderUUE;
    SwapTimer: TTimer;
    TabPopup: TPopupMenu;
    New1: TMenuItem;
    Remove2: TMenuItem;
    Rename1: TMenuItem;
    FavoritesPopup: TPopupMenu;
    AddServer1: TMenuItem;
    DeleteServer1: TMenuItem;
    UpdateData1: TMenuItem;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label2: TLabel;
    Port: TEdit;
    Pass: TEdit;
    Host: TComboBox;
    AddFavServ: TButton;
    Refresh: TBitBtn;
    Settings: TButton;
    Connect: TButton;
    IRC: TIdIRC;
    IRCConsole: TRichEdit; // TMemo;
    IRCCmd: TComboBox;
    Label10: TLabel;
    Label18: TLabel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    UserBox: TListBox;
    TeamList: TListView;
    IRCConnect: TButton;
    Kill1: TMenuItem;
    IrcSettings: TBitBtn;
    BalanceTimer: TTimer;
    ConnectPopup: TPopupMenu;
    ConnectAll1: TMenuItem;
    DisconnectAll1: TMenuItem;
    N2: TMenuItem;
    AutoRetry: TMenuItem;
    AutoConnect: TMenuItem;
    PrivateMessage1: TMenuItem;
    GlobalMute1: TMenuItem;
    Mute1: TMenuItem;
    Unmute1: TMenuItem;
    CommandPopup: TPopupMenu;
    Edit: TMenuItem;
    Add2: TMenuItem;
    Remove3: TMenuItem;
    Perform1: TMenuItem;
    MoreInfo: TLabel;
    Action: TGroupBox;
    botsCountLabel: TLabel;
    botsCount: TLabel;
    SpectCountLabel: TLabel;
    SpectCount: TLabel;
    RespawnLabel: TLabel;
    Respawn: TLabel;
    FFLabel: TLabel;
    FF: TLabel;
    BonusLabel: TLabel;
    Bonus: TLabel;
    VotingLabel: TLabel;
    Voting: TLabel;
    MoveToNone1: TMenuItem;
    ClearConsole: TButton;
    TimedIP1: TMenuItem;
    Reloadlist1: TMenuItem;
    AdminBubi: TzAPIBalloon;
    DuplicateServer1: TMenuItem;
    SayBox: TCheckBox;
    AdminBox: TCheckBox;
    ActionList: TListBox;
    IP30days1: TMenuItem;
    SpeedButton: TSpeedButton;
    NickSayBox: TCheckBox;
    HWID1: TMenuItem;
    PlayerTagID1: TMenuItem;
    ApplicationEvents1: TApplicationEvents;
    procedure ConnectClick(Sender: TObject);
    procedure ClientConnected(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure ClientDisconnected(Sender: TObject);
    procedure CmdKeyPress(Sender: TObject; var Key: Char);
    procedure RefreshClick(Sender: TObject);
    procedure RefreshTime();
    procedure PlayerListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Kick1Click(Sender: TObject);
    procedure Admin1Click(Sender: TObject);
    procedure Ban1Click(Sender: TObject);
    procedure RefreshTimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SaveConfig(filename: string);
    procedure LoadConfig(filename: string);
    procedure LoadBots(LoadWhat: integer);
    procedure LoadMaps(const maptype: byte);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MoveToAlpha1Click(Sender: TObject);
    procedure MoveToBravo1Click(Sender: TObject);
    procedure MoveToCharlie1Click(Sender: TObject);
    procedure MoveToDelta1Click(Sender: TObject);
    procedure MoveToSpectator1Click(Sender: TObject);
    procedure MoveToTeam(Sender: TObject; var Team: Char);
    procedure ConnectIt(Sender: TObject; var Key: Char);
    procedure PerformActionClick(Sender: TObject);
    procedure EnableButtons(State: boolean);
    procedure EnableConnectButtons(State: boolean);
    procedure ParameterChange(Sender: TObject);
    procedure ParameterKeyPress(Sender: TObject; var Key: Char);
    procedure Remove1Click(Sender: TObject);
    procedure HostSelect(Sender: TObject);
    procedure AddFavServClick(Sender: TObject);
    procedure HotKeyPress(Sender: TObject; var Key: Char);
    procedure TimerLeftTimer(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Restore1Click(Sender: TObject);
    procedure PlayerListColumnClick(Sender: TObject; Column: TListColumn);
    procedure PlayerListCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure AddPlayersToList(var i: shortint);
    procedure SettingsClick(Sender: TObject);
    procedure PlayerListCustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      var DefaultDraw: Boolean);
    procedure WriteToLog(Msg: string; Index: integer);
    procedure FormResize(Sender: TObject);
    procedure FormConstrainedResize(Sender: TObject; var MinWidth,
      MinHeight, MaxWidth, MaxHeight: Integer);
    function Matches(Mask, S: string): Boolean;
    procedure Kickall(const command: string; index: integer);
    procedure SwapTeams(swapkind: byte; index: integer);
    procedure AutoSayTimer(Sender: TObject);
    procedure ARSSETimerTimer(Sender: TObject);
    procedure AddARSSETimer(name, script: string; timerloop: byte; interval:
      integer; enabled: boolean; index: integer);
    procedure PlayerName1Click(Sender: TObject);
    procedure PlayerIP1Click(Sender: TObject);
    procedure FormShortCut(var Msg: TWMKey; var Handled: Boolean);
    procedure UMNotifyIcon(var Msg: TMessage); message UM_NOTIFYICON;
    procedure OpenParamInput(const Command, Msg: string);
    procedure SwapTimerTimer(Sender: TObject);
    procedure OnPlayerJoin(var Name, ip: string; index: integer);
    procedure Name1Click(Sender: TObject);
    procedure AddToBanList(var Name: string; const Ban: boolean);
    procedure DoRefresh();
    procedure Panel1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Panel1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MemoChange(Sender: TObject);
    procedure ServerTabChange(Sender: TObject);
    procedure ServerTabChanging(Sender: TObject; var AllowChange: Boolean);
    procedure AddServerClick(Sender: TObject);
    procedure RemoveServerClick(Sender: TObject);
    procedure RemoveTimer(ServerIndex, TimerIndex: integer);
    procedure MemoMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ServerTabMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Rename1Click(Sender: TObject);
    procedure ServerNameExit(Sender: TObject);
    procedure ServerNameKeyPress(Sender: TObject; var Key: Char);
    procedure UpdateData1Click(Sender: TObject);
    procedure DeleteServer1Click(Sender: TObject);
    procedure LoadScript(script: string; index: integer);
    procedure IRCConnectClick(Sender: TObject);
    procedure IRCReceive(Sender: TObject; ACommand: string);
    procedure IRCCmdKeyPress(Sender: TObject; var Key: Char);
    procedure IRCMessage(Sender: TObject; AUser: TIdIRCUser;
      AChannel: TIdIRCChannel; Content: string);
    procedure IRCConnected(Sender: TObject);
    procedure IRCDisconnected(Sender: TObject);
    procedure IRCJoined(Sender: TObject; AChannel: TIdIRCChannel);
    procedure IRCJoin(Sender: TObject; AUser: TIdIRCUser;
      AChannel: TIdIRCChannel);
    procedure IRCError(Sender: TObject; AUser: TIdIRCUser; ANumeric,
      AError: string);
    procedure IRCSystem(Sender: TObject; AUser: TIdIRCUser;
      ACmdCode: Integer; ACommand, AContent: string);
    procedure AddFavServMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure HostChange(Sender: TObject);
    procedure PortChange(Sender: TObject);
    procedure PassChange(Sender: TObject);
    procedure MemoMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure IRCMsg(Target, Msg: string);
    procedure IRCNames(Sender: TObject; AUsers: TIdIRCUsers;
      AChannel: TIdIRCChannel);
    procedure TeamListCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure TeamListCustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      var DefaultDraw: Boolean);
    procedure EventOccure(param, value, scriptfile: string; index: integer);
    procedure Kill1Click(Sender: TObject);
    procedure ParseScript(sor: string; params, values: TStringList; index:
      integer); // inif, voltmarif: boolean);
    procedure BalanceTeams(index: integer);
    procedure DoBalance(index, team, a, b: integer);
    procedure BalanceTimerTimer(Sender: TObject);
    procedure ConnectMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ConnectAll1Click(Sender: TObject);
    procedure DisconnectAll1Click(Sender: TObject);
    procedure AutoRetryClick(Sender: TObject);
    procedure AutoRetryTimer(Sender: TObject);
    procedure AutoConnectClick(Sender: TObject);
    procedure ServerTabDrawTab(Control: TCustomTabControl;
      TabIndex: Integer; const Rect: TRect; Active: Boolean);
    procedure Mute1Click(Sender: TObject);
    procedure Unmute1Click(Sender: TObject);
    procedure PrivateMessage1Click(Sender: TObject);
    procedure LoadCommandBox(filename: string);
    procedure SaveCommandBox(filename: string);
    procedure SetDialogButtons(button1, button2, button3, button4: string;
      paramvalue: boolean);
    procedure ActionListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure EditClick(Sender: TObject);
    procedure Add2Click(Sender: TObject);
    procedure Remove3Click(Sender: TObject);
    procedure ParseKills(msg: string; index: integer);
    procedure PassKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure MoreInfoMouseEnter(Sender: TObject);
    procedure MoreInfoMouseLeave(Sender: TObject);
    procedure FixNames(index: integer);
    procedure MoveToNone1Click(Sender: TObject);
    procedure AdminBubiClick(Sender: TObject);
    function TaskBarHeight: integer;
    procedure ClearConsoleClick(Sender: TObject);
    procedure CmdKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CmdChange(Sender: TObject);
    procedure TimedIP1Click(Sender: TObject);
    procedure ActionListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure Reloadlist1Click(Sender: TObject);
    procedure ManualUpdateClick(Sender: TObject);
    procedure HotKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure DuplicateServer1Click(Sender: TObject);
    procedure ServerTabMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PassExit(Sender: TObject);
    procedure DoHotkeyCommand(Commands: TStringList);
    procedure WMDrawItem(var Message: TWMDrawItem); message WM_DRAWITEM;
    procedure ServerTabEnter(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure IRCConsoleChange(Sender: TObject);
    procedure IRCConsoleKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure IRCConsoleMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure IRCConsoleMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CmdEnter(Sender: TObject);
    procedure PlayerListCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure AdminBoxClick(Sender: TObject);
    procedure SayBoxClick(Sender: TObject);
    procedure NickSayBoxClick(Sender: TObject);
    procedure SetFocusToCmd(Sender: TObject);
    procedure IP30days1Click(Sender: TObject);
    procedure SpeedButtonClick(Sender: TObject);
    procedure ActionViewAddition(Sender: TObject; Node: TTreeNode);
    procedure ActionViewAdvancedCustomDrawItem(Sender: TCustomTreeView;
      Node: TTreeNode; State: TCustomDrawState; Stage: TCustomDrawStage;
      var PaintImages, DefaultDraw: Boolean);
    procedure PlayerListInfoTip(Sender: TObject; Item: TListItem;
      var InfoTip: string);
    procedure ARSSECommands(Msg: string; Index: integer);
    procedure HandleHotKey(Key: Word);
    procedure MoreInfoClick(Sender: TObject);
    procedure HWID1Click(Sender: TObject);
    procedure PlayerTagID1Click(Sender: TObject);
    procedure ApplicationEvents1Activate(Sender: TObject);
    procedure ApplicationEvents1Deactivate(Sender: TObject);
  private
    { Private declarations }
    _NormalX: integer; //for saving window pos when maximized closing
    _NormalY: integer;
    TrayIcon: TNotifyIconData;
    Capturing: Boolean;
    ClickedTab: integer;
    columnsWidth: array[COLUMN_ID..COLUMN_NUM] of integer;
    columnsMinWidth: array[COLUMN_ID..COLUMN_NUM] of integer;
    columnsVisibility: array[COLUMN_ID..COLUMN_NUM] of boolean;
    // FUpdateActive: boolean;
    UpdtThread: TUpdateThread;
    // procedure HandleUpdateTerminate(Sender: TObject);
    procedure HandleUpdateCompletion(var Message: TMessage); message
      WM_UPDATE_COMPLETE;
    // procedure FixTrayIcon(var Message: TMessage); message WM_TASKBARCREATED;
    procedure MinimizeToTray(Sender: TObject);
    procedure RestoreMainForm;
    procedure ShowThePopup;
    procedure WMSIZE(var Msg: TWMSIZE); message WM_SIZE; //maximized window save
    procedure FormMove(var Msg: TWMMove); message WM_MOVE; //   "        "     "
    procedure OnMessageHandler(var Msg: TMsg; var Handled: Boolean);
    // procedure SetPlayerListColumnWidth(column, width: Integer);
    procedure SetPlayerListColumnWidthAndMinwidth(column: Integer; show: Boolean);
  public
    { Public declarations }
    NormalX: integer;
    NormalY: integer;
    NormalWidth: integer;
    NormalHeight: integer;
    Maximized: boolean;
    procedure WMMYMEMOENTER(var Message: TMessage);
      message WM_MYMEMO_ENTER;
    // Events: array[0..11] of TEventList;
  end;

  TFav_Serv = record
    Name: TStringList;
    Host: TStringList;
    Port: TStringList;
    Pass: TStringList;
  end;

  TIRCConfig = record
    Server, Nick, AltNick, Username, Channel, ChanKey,
      ANick, ABot, APass, ACmd, Prefix: string;
    Port: integer;
    auth: boolean;
  end;

  TCommandBox = record
    Name: string;
    Commands: TStringList;
  end;

  TARSSETimer = record
    Timer: TTimer;
    ScriptFile: string;
    Loop: byte;
  end;

  TConfigSettings = record
    savepass, savelog, autobalance, hideRegistered,
      autoswap, autosay, hideKills: boolean;
    AutoMsgDelay, balancediff: byte;
    AutoMessageList, EventFile: TStrings;
    EventOn: array[0..EVENTCOUNT] of boolean;
    Events: TStrings;
  end;

  TConfigGlobal = record
    Auto, mintotray, sortrefresh, autoupdate, PlayersOnTab: boolean;
    EventOn: array[0..EVENTCOUNT] of boolean;
    Events, EventFile, TeamKillers: TStrings;
    IRC: TIRCConfig;
    CommandBox: array[0..100] of TCommandBox;
    Hotkeys: array[0..31] of TARSSEHotkey;
    HotkeyDescription: TStrings;
    updatefreq: byte;
    updatetime: TDateTime;
    AdminName: string;
    SoundfileName: string;
    ColorMain, ColorChat, ColorTeam, ColorAdmin, ColorMuted, ColorText,
      ColorPm, ColorAdmChat, ColorClientList: TColor;
    CustomColors: TStringList;
  end;

  TServerList = record
    Client: TIdTCPClient;
    Memo: TRichEdit;
    RefreshMsg: TMsg_Refreshx_270;
    RefreshMsgVers: byte;
    ServerName: string;
    Teams: array[1..4] of byte;
    MaxPlayer, bots, specs, voting: byte;
    Pass, Maxplayers, bonus, ff, respawn: string;
    AutoRetryTimer: TTimer;
    AutoSay, SwapTimer: TTimer;
    AutoRetry, AutoConnect: boolean;
    Config: TConfigSettings;
    Timers: array[0..MAX_TIMER] of TARSSETimer;
    TimerName: TStringList;
    AutoScroll, stopparse: Boolean;
    playerFlag: array[1..MAX_PLAYERS] of byte;
    LastIP: array[1..MAX_PLAYERS, 1..4] of byte;
    joinedPlayerNicks: TStringList;  // save last joined players for chatcoloring
  end;

var
  Form1: TForm1;
  RefreshMsg: TMsg_Refresh;
  Fav_Serv: TFav_Serv;
  Config: TConfigGlobal;
  LastCmd: string = '';
  ActionID: byte = 1;
  current_server: byte;
  DefaultMaps: array[1..MAX_MAPS] of string;
  DefaultBots: array[1..MAX_BOTS] of string;
  ServerList: array[0..100] of TServerList;
  ColumnToSort: byte;
  SortDirection: shortint = -1;  // 1: asc, -1: desc
  var1, var2: string;
  voltmarif, inif, infoOn, mutathatod, logolhatsz, TabClicked: boolean;
  SelBegin: integer;
  SelectAll: boolean;
  selpos, sellen: array[0..100] of integer;
  nickcompletionlist: TStringList;  // save last matching nicks
  tabpresscount: integer;           // for iterating through nickcompletionlist
  completednick: string;            // last completed nick

  DBFile: TFlagDB;
  CountryFlags: array[0..253] of TGifImage;

  isAlwaysOnTop: boolean;

implementation

uses
  Unit2, Unit3, SettingsForm, adminbox, CmdEdig, Types, UpdatePopup, Helpers;

{$R *.dfm}

// adds text to the memo when it has focus it prevents scrolling to the end
// it resets the selection
procedure MemoAppend(memoTab: integer; TextColor: TColor; str: string);
var
  start, len, line: integer;
begin
  with ServerList[memoTab].Memo do
  begin
    if not Focused then
    begin
      HideSelection := true;
      ServerList[memoTab].Memo.SelStart := Length(ServerList[memoTab].Memo.Text);
      ServerList[memoTab].Memo.SelAttributes.Color := TextColor;
      Lines.append(str);
    end
    else
    begin
      if not((SearchForm1.visible) and (SelLength <> 0)) then
      begin
        // hide selection and remove focus
        HideSelection := true;
        SelLength := 0;
        HideCaret(ServerList[memoTab].Memo.Handle);

        if Form1.Cmd.Enabled then
          Form1.Cmd.SetFocus
        else
          Form1.Playerlist.SetFocus;

        ServerList[memoTab].Memo.SelStart := Length(ServerList[memoTab].Memo.Text);
        ServerList[memoTab].Memo.SelAttributes.Color := TextColor;
        Lines.append(str); 

        SelLength := 0;  // Really necessary?
        HideCaret(ServerList[memoTab].Memo.Handle);  // Really necessary?
      end
      else
      begin
        // NOTE: staying at the bottom doesn't work
        // keep position and highlighting
        HideSelection := true;
        start := SelStart;
        len := SelLength;
        line := Perform(EM_GETFIRSTVISIBLELINE, 0, 0);

        if Form1.Cmd.Enabled then
          Form1.Cmd.SetFocus
        else
          Form1.Playerlist.SetFocus;

        ServerList[memoTab].Memo.SelStart := Length(ServerList[memoTab].Memo.Text);
        ServerList[memoTab].Memo.SelAttributes.Color := TextColor;
        Lines.append(str);

        SetFocus;

        SelStart := Perform(EM_LINEINDEX, line, 0);
        Perform(EM_SCROLLCARET, 0, 0);
        SelStart := start;
        SelLength := len;
      end;
    end;
  end;
end;

// hides the carret
procedure TForm1.WMMYMEMOENTER(var Message: TMessage);
begin
  // CreateCaret(Memo.Handle,0,0,0) ;
end;

// Windows x64 tab text drawing fix
function DoControlMsg(ControlHandle: HWnd; var Message): Boolean;
var
  Control: TWinControl;
begin
  DoControlMsg := False;
  Control := FindControl(ControlHandle);
  if Control <> nil then
    with TMessage(Message) do
    begin
      Result := Control.Perform(Msg + CN_BASE, WParam, LParam);
      DoControlMsg := True;
    end;
end;

procedure TForm1.WMDrawItem(var Message: TWMDrawItem);
begin
  if not DoControlMsg(Message.DrawItemStruct^.hwndItem, Message) then
    inherited;
end;
// Fix end

// get current player count
function PlayerNum(index: integer): integer;
var
  i, players: integer;
begin
  players := 0;

  if ServerList[index].Client.Connected then
    for i := 1 to MAX_PLAYERS do
      if (ServerList[index].RefreshMsg.Team[i] <= MAX_TEAMS) and
        (ServerList[index].RefreshMsg.Number[i] <= MAX_PLAYERS) and
        (ServerList[index].RefreshMsg.Number[i] > 0) then
        inc(players);

  Result := players;
end;

procedure TForm1.AddPlayersToList(var i: shortint);
var
  ListItem: TListItem;
  kd: double;
begin
  ListItem := PlayerList.Items.Add;
  ListItem.Caption :=
    inttostr(ServerList[ServerTab.TabIndex].RefreshMsg.Number[i]);
  ListItem.SubItems.Add(StringReplace(ServerList[ServerTab.TabIndex].RefreshMsg.Name[i], #10, '', [rfReplaceAll]));
  begin
    // TagID
    if ServerList[ServerTab.TabIndex].RefreshMsgVers = REFRESHX_270 then
    begin
      ListItem.SubItems.Add(ServerList[ServerTab.TabIndex].RefreshMsg.HWID[i]);
    end
    else
    begin
      ListItem.SubItems.Add('0');
    end;

    // Kills
    ListItem.SubItems.Add(inttostr(ServerList[ServerTab.TabIndex].RefreshMsg.Kills[i]));

    // Caps
    if ServerList[ServerTab.TabIndex].RefreshMsgVers = REFRESHX_265 then
    begin
      ListItem.SubItems.Add(inttostr(ServerList[ServerTab.TabIndex].RefreshMsg.Caps[i]));
    end
    else
    begin
      ListItem.SubItems.Add('0');
    end;

    // Deaths
    ListItem.SubItems.Add(inttostr(ServerList[ServerTab.TabIndex].RefreshMsg.Deaths[i]));

    // Ratio
    if ServerList[ServerTab.TabIndex].RefreshMsg.Deaths[i] <> 0 then
      kd := ServerList[ServerTab.TabIndex].RefreshMsg.Kills[i] /
        ServerList[ServerTab.TabIndex].RefreshMsg.Deaths[i]
    else
      kd := 0;
    ListItem.SubItems.Add(formatfloat('0.00', kd));
  end;

  // Team
  ListItem.SubItems.Add(inttostr(ServerList[ServerTab.TabIndex].RefreshMsg.Ping[i]));
  case ServerList[ServerTab.TabIndex].RefreshMsg.Team[i] of
    0: ListItem.SubItems.Add('None');
    1: ListItem.SubItems.Add('Alpha');
    2: ListItem.SubItems.Add('Bravo');
    3: ListItem.SubItems.Add('Charlie');
    4: ListItem.SubItems.Add('Delta');
    5: ListItem.SubItems.Add('Spectator');
  else
    ListItem.SubItems.Add(inttostr(ServerList[ServerTab.TabIndex].RefreshMsg.Team[i]));
  end;

  // Ping
  if (inttostr(ServerList[ServerTab.TabIndex].RefreshMsg.IP[i][1]) + '.' +
    inttostr(ServerList[ServerTab.TabIndex].RefreshMsg.IP[i][2]) + '.' +
    inttostr(ServerList[ServerTab.TabIndex].RefreshMsg.IP[i][3]) + '.' +
    inttostr(ServerList[ServerTab.TabIndex].RefreshMsg.IP[i][4])) = '0.0.0.0'
      then
    ListItem.SubItems.Add('Bot')
  else
    ListItem.SubItems.Add(inttostr(ServerList[ServerTab.TabIndex].RefreshMsg.IP[i][1]) + '.' +
      inttostr(ServerList[ServerTab.TabIndex].RefreshMsg.IP[i][2]) + '.' +
      inttostr(ServerList[ServerTab.TabIndex].RefreshMsg.IP[i][3]) + '.' +
      inttostr(ServerList[ServerTab.TabIndex].RefreshMsg.IP[i][4]));
end;

// add playerip to remote admin list
procedure TForm1.Admin1Click(Sender: TObject);
var
  i: integer;
  S: string;
  ch: char;
begin
  if PlayerList.Items.Count = 0 then
    exit;

  i := PlayerList.Itemindex;
  if (i < 0) or (i > (PlayerList.Items.Count - 1)) then
    exit;

  S := PlayerList.Items[i].SubItems[ITEM_IP];

  Cmd.Text := '/admip ' + S;
  ch := #13;
  CmdKeyPress(nil, ch);
end;

procedure TForm1.EnableButtons(State: boolean);
begin
  Refresh.Enabled := State;
  // Shutdown.Enabled:= State;
  ActionList.Enabled := State;
  //PerformAction.Enabled := State;
  Cmd.Enabled := State;
  TimerLeft.Enabled := State;
  // RefreshTimer.Enabled:= State;
  AdminBox.Enabled := State;
  SayBox.Enabled := State;
  NickSayBox.Enabled := State;
end;

procedure TForm1.EnableConnectButtons(State: boolean);
begin
  Host.Enabled := State;
  Port.Enabled := State;
  Pass.Enabled := State;
end;

procedure TForm1.SetDialogButtons(button1, button2, button3, button4: string;
  paramvalue: boolean);
begin

  MyDialogBox.ParamValue.Visible := paramvalue;

  if button1 = 'false' then
    MyDialogBox.AlphaButton.Visible := false
  else
  begin
    MyDialogBox.AlphaButton.Visible := true;
    MyDialogBox.AlphaButton.Caption := button1;
  end;

  if button2 = 'false' then
    MyDialogBox.BravoButton.Visible := false
  else
  begin
    MyDialogBox.BravoButton.Visible := true;
    MyDialogBox.BravoButton.Caption := button2;
  end;

  if button3 = 'false' then
    MyDialogBox.CharlieButton.Visible := false
  else
  begin
    MyDialogBox.CharlieButton.Visible := true;
    MyDialogBox.CharlieButton.Caption := button3;
  end;

  if button4 = 'false' then
    MyDialogBox.DeltaButton.Visible := false
  else
  begin
    MyDialogBox.DeltaButton.Visible := true;
    MyDialogBox.DeltaButton.Caption := button4;
  end;
end;

procedure TForm1.WriteToLog(Msg: string; Index: integer);
const
  DATEFORMATE = 'yyyy_mm_dd';
var
  f: TextFile;
begin
  if ServerList[index].Config.savelog then
  begin
    if not DirectoryExists(ExtractFilePath(Application.ExeName) + 'logs') then
      Mkdir(ExtractFilePath(Application.ExeName) + 'logs');
    if not DirectoryExists(ExtractFilePath(Application.ExeName) + 'logs\' +
      ServerList[index].ServerName + '.log') then
      Mkdir(ExtractFilePath(Application.ExeName) + 'logs\' +
        ServerList[index].ServerName + '.log');
    Assignfile(F, ExtractFilePath(Application.ExeName) + 'logs\' +
      ServerList[index].ServerName + '.log\' +
      FormatDateTime(DATEFORMATE, Date) + '.txt');
    //ServerList[index].Client.Host
//  Assignfile(F, ExtractFilePath(Application.ExeName)+'logs\' + ServerList[index].ServerName + '.txt'); //ServerList[index].Client.Host
    if not FileExists(ExtractFilePath(Application.ExeName) + 'logs\' +
      ServerList[index].ServerName + '.log\' +
      FormatDateTime(DATEFORMATE, Date) + '.txt') then
      Rewrite(F)
        //  if not FileExists(ExtractFilePath(Application.ExeName)+'logs\' + ServerList[index].ServerName + '.txt') then Rewrite(F)
    else
      Append(F);
    WriteLn(F, Msg);
    Flush(f);
    CloseFile(f);
  end;
end;

procedure TForm1.SaveConfig(filename: string);
var
  ini: TMeminifile;
  conf: Tstringlist;
  i, j: shortint;
  // started, finished: TDateTime;
begin
  // started:= GetTime;

  conf := Tstringlist.create;
  ini := TMeminifile.Create(filename);

  ////////////// Global Settings ///////////

  Ini.WriteString('ADMIN', 'AdminName', Config.AdminName);
  Ini.WriteString('ADMIN', 'SoundfileName', Config.SoundFileName);
  if Config.Auto then
    Ini.WriteString('ADMIN', 'Refresh', '1')
  else
    Ini.WriteString('ADMIN', 'Refresh', '0');
  Ini.WriteString('ADMIN', 'RefreshTime', inttostr(RefreshTimer.Interval div
    1000));
  if Config.mintotray then
    Ini.WriteString('ADMIN', 'MinToTray', '1')
  else
    Ini.WriteString('ADMIN', 'MinToTray', '0');

  if Config.sortrefresh then
    Ini.WriteString('ADMIN', 'AutoSort', '1')
  else
    Ini.WriteString('ADMIN', 'AutoSort', '0');

  if Config.PlayersOnTab then
    Ini.WriteString('ADMIN', 'PlayersOnTab', '1')
  else
    Ini.WriteString('ADMIN', 'PlayersOnTab', '0');

  if Config.autoupdate then
    Ini.WriteString('ADMIN', 'AutoUpdate', '1')
  else
    Ini.WriteString('ADMIN', 'AutoUpdate', '0');

  Ini.WriteString('ADMIN', 'UpdateFrequency', inttostr(Config.updatefreq));
  Ini.WriteString('ADMIN', 'LastUpdate', DateToStr(Config.updatetime));

  Ini.WriteString('ADMIN', 'TabIndex', inttostr(ServerTab.Tabindex));

  Ini.WriteString('ADMIN', 'Maximized', inttostr(integer(Form1.Maximized)));
  if not Form1.Maximized then
  begin
    Ini.WriteString('ADMIN', 'Left', inttostr(Form1.Left));
    Ini.WriteString('ADMIN', 'Top', inttostr(Form1.Top));
    Ini.WriteString('ADMIN', 'Width', inttostr(Form1.Width));
    Ini.WriteString('ADMIN', 'Height', inttostr(Form1.Height));
  end
  else
  begin
    Ini.WriteString('ADMIN', 'Left', inttostr(Form1.NormalX));
    Ini.WriteString('ADMIN', 'Top', inttostr(Form1.NormalY));
    Ini.WriteString('ADMIN', 'Width', inttostr(Form1.NormalWidth));
    Ini.WriteString('ADMIN', 'Height', inttostr(Form1.NormalHeight));
  end;

  Ini.WriteString('ADMIN', 'PanelPos', inttostr(Panel1.Top));

  for j := 0 to EVENTGLOBAL do
  begin
    ini.WriteString('ADMIN', 'EventFile' + inttostr(j), Config.EventFile[j]);
    if Config.EventOn[j] then
      ini.WriteString('ADMIN', 'EventOn' + inttostr(j), '1')
    else
      ini.WriteString('ADMIN', 'EventOn' + inttostr(j), '0')
  end;

  for j := 0 to Settings1.HotkeyList.Items.Count-1 do
  begin
    // save hotkey settings and assign them
    Config.Hotkeys[j].Text := Settings1.HotkeyList.Items.Item[j].Caption;
    Config.Hotkeys[j].Shift := HotkeyShift[j];
    Config.Hotkeys[j].Key := HotkeyNumber[j];
    ini.WriteString('HOTKEYS', 'Key' + inttostr(j), Config.Hotkeys[j].Text );
  end;
  /////////////// Colors ////////////////////

  //  ColorMain, ColorChat, ColorTeam, ColorAdmin, ColorMuted, ColorText,
  //      ColorPm, ColorAdmChat: TColor;

  Ini.WriteString('COLORS', 'ColorMain', ColorToString(Config.ColorMain));
  Ini.WriteString('COLORS', 'ColorChat', ColorToString(Config.ColorChat));
  Ini.WriteString('COLORS', 'ColorTeam', ColorToString(Config.ColorTeam));
  Ini.WriteString('COLORS', 'ColorAdmin', ColorToString(Config.ColorAdmin));
  Ini.WriteString('COLORS', 'ColorMuted', ColorToString(Config.ColorMuted));
  Ini.WriteString('COLORS', 'ColorText', ColorToString(Config.ColorText));
  Ini.WriteString('COLORS', 'ColorPm', ColorToString(Config.ColorPm));
  Ini.WriteString('COLORS', 'ColorAdmChat', ColorToString(Config.ColorAdmChat));
  Ini.WriteString('COLORS', 'ColorClientList',
    ColorToString(Config.ColorClientList));
  Ini.WriteString('COLORS', 'ConsoleFont', Memo.Font.Name);

  Ini.EraseSection('CUSTOMCOLORS');

  if Config.CustomColors.Count > 0 then
    for i := 0 to Config.CustomColors.Count - 1 do
    begin
      Ini.WriteString('CUSTOMCOLORS', Config.CustomColors.Names[i],
        Config.CustomColors.ValueFromIndex[i]);
    end;

  /////////////// IRC Settings /////////////////////////

  Ini.WriteString('IRC', 'IP', Config.IRC.Server); //IRCServer.Text);
  Ini.WriteString('IRC', 'Port', inttostr(Config.IRC.Port)); //IRCPort.Text);
  Ini.WriteString('IRC', 'Nick', Config.IRC.Nick); //IRCNick.Text);
  Ini.WriteString('IRC', 'AltNick', Config.IRC.AltNick);
  Ini.WriteString('IRC', 'Username', Config.IRC.Username);
  Ini.WriteString('IRC', 'Prefix', Config.IRC.Prefix);
  Ini.WriteString('IRC', 'Channel', Config.IRC.Channel); //IRCChannel.Text);
  Ini.WriteString('IRC', 'Key', Config.IRC.ChanKey); //IRCKey.Text);
  if Config.IRC.auth then
    Ini.WriteString('IRC', 'QNetAuth', '1')
  else
    Ini.WriteString('IRC', 'QNetAuth', '0');
  Ini.WriteString('IRC', 'QUser', Config.IRC.ANick); //QNetUser.Text);
  Ini.WriteString('IRC', 'QPass', Config.IRC.APass); //QNetPass.Text);
  Ini.WriteString('IRC', 'ABot', Config.IRC.ABot);
  Ini.WriteString('IRC', 'ACmd', Config.IRC.ACmd);

  //////////////// Server Specific Settings ////////////

  i := 0;
  repeat
    Ini.EraseSection('AUTOMESSAGE' + inttostr(i));
    inc(i);
  until not Ini.SectionExists('AUTOMESSAGE' + inttostr(i));

  i := 0;
  repeat
    Ini.EraseSection('EVENTS' + inttostr(i));
    inc(i);
  until not Ini.SectionExists('EVENTS' + inttostr(i));

  i := 0;
  repeat
    Ini.EraseSection('TIMERS' + inttostr(i));
    inc(i);
  until not Ini.SectionExists('TIMERS' + inttostr(i));

  i := 0;
  repeat
    Ini.EraseSection('TAB' + inttostr(i));
    inc(i);
  until not Ini.SectionExists('TAB' + inttostr(i));

  for i := 0 to ServerTab.Tabs.Count - 1 do
  begin

    if ServerList[i].Config.savepass then
      Ini.WriteString('TAB' + inttostr(i), 'SavePass', '1')
    else
      Ini.WriteString('TAB' + inttostr(i), 'SavePass', '0');

    if ServerList[i].Config.savelog then
      Ini.WriteString('TAB' + inttostr(i), 'Logging', '1')
    else
      Ini.WriteString('TAB' + inttostr(i), 'Logging', '0');

    if ServerList[i].Config.autoswap then
      Ini.WriteString('TAB' + inttostr(i), 'AutoSwap', '1')
    else
      Ini.WriteString('TAB' + inttostr(i), 'AutoSwap', '0');

    if ServerList[i].Config.autobalance then
      Ini.WriteString('TAB' + inttostr(i), 'AutoBalance', '1')
    else
      Ini.WriteString('TAB' + inttostr(i), 'AutoBalance', '0');
    Ini.WriteString('TAB' + inttostr(i), 'BalanceDiff',
      inttostr(ServerList[i].Config.balancediff));

    if ServerList[i].Config.hideRegistered then
      Ini.WriteString('TAB' + inttostr(i), 'HideLobby', '1')
    else
      Ini.WriteString('TAB' + inttostr(i), 'HideLobby', '0');

    if ServerList[i].Config.hideKills then
      Ini.WriteString('TAB' + inttostr(i), 'HideKills', '1')
    else
      Ini.WriteString('TAB' + inttostr(i), 'HideKills', '0');

    if ServerList[i].AutoSay.Enabled then
      Ini.WriteString('TAB' + inttostr(i), 'AutoMsg', '1')
    else
      Ini.WriteString('TAB' + inttostr(i), 'AutoMsg', '0');
    Ini.WriteString('TAB' + inttostr(i), 'AutoMsgDelay',
      inttostr(ServerList[i].AutoSay.Interval div 1000));

    for j := 0 to ServerList[i].TimerName.Count - 1 do
    begin
      Ini.WriteString('TIMERS' + inttostr(i), 'TimerName' + inttostr(j),
        ServerList[i].TimerName[j]);
      Ini.WriteString('TIMERS' + inttostr(i), 'ScriptFile' + inttostr(j),
        ServerList[i].Timers[j].ScriptFile);
      Ini.WriteString('TIMERS' + inttostr(i), 'Interval' + inttostr(j),
        inttostr(ServerList[i].Timers[j].Timer.Interval));
      Ini.WriteString('TIMERS' + inttostr(i), 'Enabled' + inttostr(j),
        booltostr(ServerList[i].Timers[j].Timer.Enabled));
      Ini.WriteString('TIMERS' + inttostr(i), 'Loop' + inttostr(j),
        inttostr(ServerList[i].Timers[j].Loop));
    end;

    for j := 0 to ServerList[i].Config.AutoMessageList.Count - 1 do
      Ini.WriteString('AUTOMESSAGE' + inttostr(i), inttostr(j),
        ServerList[i].Config.AutoMessageList[j]);

    for j := 0 to EVENTCOUNT do
      if (j > 1) and (j < 13) then
      begin
        ini.WriteString('EVENTS' + inttostr(i), 'EventFile' + inttostr(j),
          ServerList[i].Config.EventFile[j]);
        if ServerList[i].Config.EventOn[j] then
          ini.WriteString('EVENTS' + inttostr(i), 'EventOn' + inttostr(j), '1')
        else
          ini.WriteString('EVENTS' + inttostr(i), 'EventOn' + inttostr(j), '0')
      end;

    //  Ini.WriteString('TAB'+inttostr(i),'Name',ServerTab.Tabs[i]);
    Ini.WriteString('TAB' + inttostr(i), 'Name', ServerList[i].ServerName);
    Ini.WriteString('TAB' + inttostr(i), 'Host', ServerList[i].Client.Host);
    Ini.WriteString('TAB' + inttostr(i), 'Port',
      inttostr(ServerList[i].Client.Port));
    if ServerList[i].Config.savepass then
      Ini.WriteString('TAB' + inttostr(i), 'Pass',
        idEncoderUUE1.Encode(ServerList[i].Pass))
    else
      Ini.WriteString('TAB' + inttostr(i), 'Pass', '');
    if ServerList[i].AutoRetry then
      Ini.WriteString('TAB' + inttostr(i), 'AutoRetry', '1')
    else
      Ini.WriteString('TAB' + inttostr(i), 'AutoRetry', '0');
    if ServerList[i].AutoConnect then
      Ini.WriteString('TAB' + inttostr(i), 'AutoConnect', '1')
    else
      Ini.WriteString('TAB' + inttostr(i), 'AutoConnect', '0');

  end;

  ini.UpdateFile;
  ini.free;
  conf.free;
end;

procedure TForm1.LoadConfig(filename: string);
var
  ini: Tinifile;
  conf, sections: Tstringlist;
  f: textfile;
  i, j, k, TabI: integer;
const
  defaultkeys: array[0..17] of string =
    (
    'Ctrl+b', 'Ctrl+c', 'Ctrl+d', 'Ctrl+e', 'Ctrl+End', 'Ctrl+f', 'Ctrl+Home',
    'Ctrl+i', 'Ctrl+k', 'Ctrl+n', 'Ctrl+p', 'Ctrl+PgDn', 'Ctrl+PgUp', 'Ctrl+r',
    'Ctrl+t', 'Ctrl+w', 'Ctrl+z', 'Ctrl+l'
    );
begin
  //Flush(f);  // IO 103 error
  TabI := 0;
  Fav_Serv.Name := TStringList.Create;
  Fav_Serv.Host := TStringList.Create;
  Fav_Serv.Port := TStringList.Create;
  Fav_Serv.Pass := TStringList.Create;
  conf := Tstringlist.create;
  ini := Tinifile.Create(filename);

  if not assigned(ini) then
  begin
    Form1.Position := poDesktopCenter;
    exit;
  end;

  ///////////// Global Settings /////////////

  ini.ReadSectionValues('ADMIN', conf);

  if conf.values['AdminName'] <> '' then
    Config.AdminName := conf.values['AdminName'];
  if conf.values['SoundfileName'] <> '' then
    Config.SoundFileName := conf.values['SoundfileName'];
  if conf.values['Refresh'] = '1' then
    Config.Auto := true
  else
    Config.Auto := false;
  if conf.values['RefreshTime'] <> '' then
    RefreshTimer.Interval := strtoint(conf.values['RefreshTime']) * 1000
  else
    RefreshTimer.Interval := 5000;

  if conf.values['MinToTray'] = '1' then
    Config.mintotray := true
  else
    Config.mintotray := false;

  if conf.values['PlayersOnTab'] = '1' then
    Config.PlayersOnTab := true
  else
    Config.PlayersOnTab := false;

  if conf.values['AutoUpdate'] = '1' then
    Config.autoupdate := true
  else
    Config.autoupdate := true;

  if conf.values['UpdateFrequency'] <> '' then
    Config.updatefreq := strtoint(conf.values['UpdateFrequency'])
  else
    Config.updatefreq := 2;

  if conf.values['LastUpdate'] <> '' then
    try
      Config.updatetime := StrToDate(conf.values['LastUpdate'])
    except
    end
  else
    Config.updatetime := Date;

  if conf.values['Left'] <> '' then
    Form1.Left := strtoint(conf.values['Left']);
  if conf.values['Top'] <> '' then
    Form1.Top := strtoint(conf.values['Top']);
  if conf.values['Width'] <> '' then
    Form1.Width := strtoint(conf.values['Width']);
  if conf.values['Height'] <> '' then
    Form1.Height := strtoint(conf.values['Height']);

  if conf.values['Maximized'] = '1' then
  begin
    Form1.WindowState := wsMaximized;
  end;

  if conf.values['PanelPos'] <> '' then
  begin
    Panel1.Top := strtoint(conf.values['PanelPos']);
    PlayerList.Height := Panel1.Top - PlayerList.Top;
    Memo.Top := Panel1.Top + 7;
  end;

  if conf.values['TabIndex'] <> '' then
    TabI := strtoint(conf.values['TabIndex']);

  // -1 creates access violations
  if TabI < 0 then
    TabI := 0;

  if conf.values['AutoSort'] = '1' then
    Config.sortrefresh := true
  else
    Config.sortrefresh := false;

  for j := 0 to EVENTGLOBAL do
  begin
    Config.EventFile[j] := conf.values['EventFile' + inttostr(j)];
    if conf.values['EventOn' + inttostr(j)] = '1' then
      Config.EventOn[j] := true
    else
      Config.EventOn[j] := false;
  end;

  ini.ReadSectionValues('HOTKEYS', conf);

  for j := 0 to Config.HotkeyDescription.Count - 1 do
  begin
    try
      // check if key exists in ini file
      k := conf.IndexOfName('Key'+IntToStr(j));
      if k = -1 then
        Config.Hotkeys[j] := StrToARSSEHotkey(defaultkeys[j]) // load default key
      else
        Config.Hotkeys[j] := StrToARSSEHotkey(conf.ValueFromIndex[k]); // load saved key
    except
      // Hotkey Key'j' could not be loaded so assume it's not assigned
      Config.Hotkeys[j].Text := ' ';
      Config.Hotkeys[j].Shift := [];
      Config.Hotkeys[j].Key := 0;
    end;
  end;

  ini.ReadSectionValues('COLORS', conf);

  if conf.values['ColorMain'] <> '' then
    Config.ColorMain := stringToColor(conf.values['ColorMain']);
  if conf.values['ColorChat'] <> '' then
    Config.ColorChat := stringToColor(conf.values['ColorChat']);
  if conf.values['ColorTeam'] <> '' then
    Config.ColorTeam := stringToColor(conf.values['ColorTeam']);
  if conf.values['ColorAdmin'] <> '' then
    Config.ColorAdmin := stringToColor(conf.values['ColorAdmin']);
  if conf.values['ColorMuted'] <> '' then
    Config.ColorMuted := stringToColor(conf.values['ColorMuted']);
  if conf.values['ColorText'] <> '' then
    Config.ColorText := stringToColor(conf.values['ColorText']);
  if conf.values['ColorPm'] <> '' then
    Config.ColorPm := stringToColor(conf.values['ColorPm']);
  if conf.values['ColorAdmChat'] <> '' then
    Config.ColorAdmChat := stringToColor(conf.values['ColorAdmChat']);
  if conf.values['ColorClientList'] <> '' then
    Config.ColorClientList := stringToColor(conf.values['ColorClientList']);
  if conf.values['ConsoleFont'] <> '' then
    Memo.Font.Name := conf.values['ConsoleFont'];

  ini.ReadSectionValues('CUSTOMCOLORS', conf);

  // Config.CustomColors:= conf;

  if conf.Count > 0 then
    for i := 0 to conf.Count - 1 do
    begin
      if (conf.Strings[i] <> '') then
        //and (Matches('cl*', conf.Strings[i]) or Matches('$????????', conf.Strings[i])) then
        Config.CustomColors.Add(conf.Strings[i])
          //    else if not Matches('cl*',conf.Strings[i]) and not Matches('$????????', conf.Strings[i]) then
//       Config.CustomColors.Add(conf.Names[i]+'=clBlack');
    end;

  {  if Config.CustomColors.Count>0 then
   for i:=0 to Config.CustomColors.Count-1 do
    begin
      Ini.WriteString('CUSTOMCOLORS',Config.CustomColors.Names[i] , Config.CustomColors.ValueFromIndex[i] );
    end;
  }

  ini.ReadSectionValues('IRC', conf);

  if conf.values['IP'] <> '' then
    Config.IRC.Server := conf.values['IP'];
  if conf.values['Port'] <> '' then
    Config.IRC.Port := strtoint(conf.values['Port']);
  if conf.values['Nick'] <> '' then
    Config.IRC.Nick := conf.values['Nick'];
  if conf.values['AltNick'] <> '' then
    Config.IRC.AltNick := conf.values['AltNick'];
  if conf.values['Username'] <> '' then
    Config.IRC.Username := conf.values['Username'];
  if conf.values['Channel'] <> '' then
    Config.IRC.Channel := conf.values['Channel'];
  if conf.values['Key'] <> '' then
    Config.IRC.ChanKey := conf.values['Key'];
  if conf.values['Prefix'] <> '' then
    Config.IRC.Prefix := conf.values['Prefix'];
  if conf.values['QNetAuth'] = '1' then
    Config.IRC.auth := true
  else
    Config.IRC.auth := false;
  if conf.values['QUser'] <> '' then
    Config.IRC.ANick := conf.values['QUser'];
  if conf.values['QPass'] <> '' then
    Config.IRC.APass := conf.values['QPass'];
  if conf.values['ABot'] <> '' then
    Config.IRC.ABot := conf.values['ABot'];
  if conf.values['ACmd'] <> '' then
    Config.IRC.ACmd := conf.values['ACmd'];

  i := 0;
  if Ini.SectionExists('TAB0') then
    while Ini.SectionExists('TAB' + inttostr(i)) do
    begin

      ini.ReadSectionValues('TAB' + inttostr(i), conf);

      AddServerClick(nil);

      if conf.values['SavePass'] = '1' then
        ServerList[i].Config.savepass := true
      else
        ServerList[i].Config.savepass := false;
      if conf.values['Logging'] = '1' then
        ServerList[i].Config.savelog := true
      else
        ServerList[i].Config.savelog := false;

      if conf.values['AutoSwap'] = '1' then
        ServerList[i].Config.autoswap := true
      else
        ServerList[i].Config.autoswap := false;

      if conf.values['AutoBalance'] = '1' then
        ServerList[i].Config.autobalance := true
      else
        ServerList[i].Config.autobalance := false;
      if conf.values['BalanceDiff'] <> '' then
        ServerList[i].Config.balancediff :=
          strtoint(conf.values['BalanceDiff']);

      if conf.values['HideLobby'] = '1' then
        ServerList[i].Config.hideRegistered := true
      else
        ServerList[i].Config.hideRegistered := false;

      if conf.values['HideKills'] = '1' then
        ServerList[i].Config.hideKills := true
      else
        ServerList[i].Config.hideKills := false;

      if conf.values['AutoMsg'] = '1' then
        ServerList[i].AutoSay.Enabled := true
      else
        ServerList[i].AutoSay.Enabled := false;
      if conf.values['AutoMsgDelay'] <> '' then
        ServerList[i].AutoSay.Interval := strtoint(conf.values['AutoMsgDelay'])
          * 1000;

      ServerTab.Tabs[i] := conf.values['Name'];
      ServerList[i].ServerName := conf.values['Name'];

      ServerList[i].Client.Host := conf.values['Host'];
      ServerList[i].Client.Port := strtoint(conf.values['Port']);
      ServerList[i].Pass := idDecoderUUE1.DecodeToString(conf.values['Pass']);
      if conf.values['AutoRetry'] = '1' then
        ServerList[i].AutoRetry := true
      else
        ServerList[i].AutoRetry := false;
      if conf.values['AutoConnect'] = '1' then
        ServerList[i].AutoConnect := true
      else
        ServerList[i].AutoConnect := false;

      ServerList[i].AutoScroll := true;

      if Ini.SectionExists('EVENTS0') then
      begin

        ini.ReadSectionValues('EVENTS' + inttostr(i), conf);

        for j := 0 to EVENTCOUNT do
          if (j > 1) and (j < 13) then
          begin
            ServerList[i].Config.EventFile[j] := conf.values['EventFile' +
              inttostr(j)];
            if conf.values['EventOn' + inttostr(j)] = '1' then
              ServerList[i].Config.EventOn[j] := true
            else
              ServerList[i].Config.EventOn[j] := false;
          end;
      end;

      ini.ReadSectionValues('TIMERS' + inttostr(i), conf);
      j := 0;
      while (conf.Values['TimerName' + inttostr(j)] <> '') and (j <= MAX_TIMER) do
      begin
        AddARSSETimer(
          conf.Values['TimerName' + inttostr(j)],
          conf.Values['ScriptFile' + inttostr(j)],
          strtoint(conf.Values['Loop' + inttostr(j)]),
          strtoint(conf.Values['Interval' + inttostr(j)]),
          strtobool(conf.Values['Enabled' + inttostr(j)]),
          i
          );
        inc(j);
      end;

      ini.ReadSectionValues('AUTOMESSAGE' + inttostr(i), conf);
      j := 0;
      while conf.Values[inttostr(j)] <> '' do
      begin
        ServerList[i].Config.AutoMessageList.Add(conf.Values[inttostr(j)]);
        inc(j);
      end;

      if ServerList[i].AutoConnect then
      begin
        MemoAppend(i, ServerList[i].Memo.Font.Color, '(' + FormatDateTime('hh:mm:ss', now) + ') ' +
          'Connecting to ' + ServerList[i].Client.Host + ':' +
          inttostr(ServerList[i].Client.Port) + '...');

        WriteToLog('Session Start: ' +
          FormatDateTime('ddd mmm dd hh:mm:ss yyyy', now), i);
        WriteToLog('(' + FormatDateTime('hh:mm:ss', now) + ') ' +
          'Connecting to ' + ServerList[i].Client.Host + ':' +
          inttostr(ServerList[i].Client.Port) + '...', i);
        if i = TabI then
        begin
          Connect.Caption := 'Disconnect';
          EnableConnectButtons(false);
          EnableButtons(true);
          if ServerList[i].AutoConnect then
            AutoConnect.Checked := true
          else
            AutoConnect.Checked := false;
        end;

        try
          ServerList[i].Client.Connect(2500);
        except
          MemoAppend(i, ServerList[i].Memo.Font.Color, '(' + FormatDateTime('hh:mm:ss', now) + ') ' +
            'Connection failed.');
          WriteToLog('(' + FormatDateTime('hh:mm:ss', now) + ') ' +
            'Connection failed.', i);
          WriteToLog('Session Close: ' +
            FormatDateTime('ddd mmm dd hh:mm:ss yyyy', now), i);
          WriteToLog('', i);
          if i = TabI then
          begin
            Connect.Caption := 'Connect';
            EnableConnectButtons(true);
            EnableButtons(false);
          end;
        end;
      end;

      inc(i);
    end
  else
  begin
    AddServerClick(nil);
  end;

  i := TabI;
  ServerTab.TabIndex := i;
  Host.Text := ServerList[i].Client.Host;
  Port.Text := inttostr(ServerList[i].Client.Port);
  Pass.Text := ServerList[i].Pass;

  ServerList[i].Memo.Visible := true;
  AutoRetry.Checked := ServerList[i].AutoRetry;

  ini.free;
  conf.free;

  if not fileexists(filename) then
  begin
    Config.Auto := true;
    Config.sortrefresh := true;

    Config.mintotray := true;

    ServerList[i].Config.savepass := true;
    ServerList[i].Config.savelog := true;
    ServerList[i].Config.hideRegistered := true;
    ServerList[i].Config.EventFile[7] := 'script\OnPlayerSpeak.txt';
    ServerList[i].Config.EventFile[11] := 'script\OnData.txt';
    ServerList[i].Config.EventOn[7] := true;
    ServerList[i].Config.EventOn[11] := true;
    Config.IRC.Prefix := '!';
    Config.IRC.ABot := 'Q@CServe.quakenet.org';
    Config.IRC.ACmd := 'AUTH';
  end;

  {
  //////// Loading Teamkillers ////////

    conf:=Tstringlist.create;
    ini:=Tinifile.Create('teamkillers.ini');

    ini.free;
    conf.Free;
  }

  //Loading favorite servers
  conf := Tstringlist.create;
  sections := Tstringlist.create;
  ini := Tinifile.Create(ExtractFilePath(Application.ExeName) +
    'fav_servers.ini');

  ini.ReadSections(sections);

  for i := 0 to sections.Count - 1 do
  begin
    ini.ReadSectionValues(sections[i], conf);

    Fav_Serv.Name.Add(conf.values['Name']);
    Fav_Serv.Host.Add(conf.values['Host']);
    Fav_Serv.Port.Add(conf.values['Port']);
    Fav_Serv.Pass.Add(idDecoderUUE1.DecodeToString(conf.values['Pass']));

    Host.Items.Add(Fav_Serv.Host[i]);
  end;

  ini.free;
  conf.free;
  sections.free;

  // Loading Bots data from file
  AssignFile(F, ExtractFilePath(Application.ExeName) + 'botlist.txt');

  if not fileexists(ExtractFilePath(Application.ExeName) + 'botlist.txt') then
  begin
    MessageDlg('Bot list file not found.', mtInformation, [mbOk], 0);
    Rewrite(F);
  end;

  Reset(F);
  i := 0;
  while not EOF(F) do
  begin
    inc(i);
    if i > MAX_BOTS then
      break;
    Readln(F, DefaultBots[i]);
  end;
  CloseFile(F);

  // Loading Maps from file
  AssignFile(F, ExtractFilePath(Application.ExeName) + 'maplist.txt');

  if not fileexists(ExtractFilePath(Application.ExeName) + 'maplist.txt') then
  begin
    MessageDlg('Map list file not found.', mtInformation, [mbOk], 0);
    Rewrite(F);
  end;

  Reset(F);
  i := 0;
  while not EOF(F) do
  begin
    inc(i);
    if i > MAX_MAPS then
      break;
    Readln(F, DefaultMaps[i]);
  end;

  CloseFile(F);
end;

procedure TForm1.LoadBots(LoadWhat: integer);
var
  i: integer;
  f: textfile;
  seged: string;
begin

  if LoadWhat = 1 then
  begin
    BotHelp.BotList.Clear;
    BotHelp.Caption := 'Default Bot Names';

    for i := 1 to MAX_BOTS do
    begin
      if DefaultBots[i] = '' then
        break;
      BotHelp.BotList.Items.Add(DefaultBots[i]);
    end;
  end;

  if LoadWhat = 2 then
  begin
    BotHelp.BotList.Clear;
    BotHelp.Caption := 'Banned Names';

    if not fileexists(ExtractFilePath(Application.ExeName) + 'bannames.txt')
      then
      exit;

    AssignFile(F, ExtractFilePath(Application.ExeName) + 'bannames.txt');

    Reset(F);
    while not EOF(F) do
    begin
      Readln(F, seged);
      BotHelp.BotList.Items.Add(seged);
    end;
    CloseFile(F);

    if BotHelp.BotList.Items.Count < 1 then
      BotHelp.Enabled := false;
  end;
end;

procedure TForm1.LoadMaps(const maptype: byte);
var
  i: integer;
  addmap: boolean;
begin

  addmap := false;
  BotHelp.BotList.Clear;
  BotHelp.Caption := 'Default Maps';

  for i := 1 to MAX_MAPS do
  begin
    case maptype of
      //DM, PM, RM, TDM
      1: if (Pos('ctf_', DefaultMaps[i]) > 0) or (Pos('inf_', DefaultMaps[i]) >
          0) or (Pos('htf_', DefaultMaps[i]) > 0) then
          addmap := false
        else
          addmap := true;
      //CTF
      2: if Pos('ctf_', DefaultMaps[i]) > 0 then
          addmap := true
        else
          addmap := false;
      //INF
      3: if Pos('inf_', DefaultMaps[i]) > 0 then
          addmap := true
        else
          addmap := false;
      4: if Pos('htf_', DefaultMaps[i]) > 0 then
          addmap := true
        else
          addmap := false;

    end;

    if DefaultMaps[i] = '' then
      break;
    if addmap then
      BotHelp.BotList.Items.Add(DefaultMaps[i]);
  end;

end;

procedure TForm1.ConnectClick(Sender: TObject);
var
  serverport: Integer;
begin
  if not ServerList[ServerTab.TabIndex].Client.Connected then
  begin
    ServerList[ServerTab.TabIndex].Client.Host := Host.Text;

    //make sure that port is valid input
    if not (TryStrToInt(Port.Text, serverport)) then
    begin
      serverport := 0;
      Port.Text := '0';
    end;
    ServerList[ServerTab.TabIndex].Client.Port := serverport;

    MemoAppend(ServerTab.TabIndex, ServerList[ServerTab.TabIndex].Memo.Font.Color, '(' + FormatDateTime('hh:mm:ss', now) + ') '
      + 'Connecting to ' + ServerList[ServerTab.TabIndex].Client.Host + ':' +
      inttostr(ServerList[ServerTab.TabIndex].Client.Port) + '...');
    WriteToLog('Session Start: ' + FormatDateTime('ddd mmm dd hh:mm:ss yyyy',
      now), ServerTab.TabIndex);
    WriteToLog('(' + FormatDateTime('hh:mm:ss', now) + ') ' + 'Connecting to ' +
      ServerList[ServerTab.TabIndex].Client.Host + ':'
      + inttostr(ServerList[ServerTab.TabIndex].Client.Port) + '...',
      ServerTab.TabIndex);

    if IRC.Connected then
      IRC.WriteLn('PRIVMSG ' + Config.IRC.Channel + ' :Connecting to ' +
        ServerList[ServerTab.TabIndex].Client.Host + ':' +
        inttostr(ServerList[ServerTab.TabIndex].Client.Port) + '...');

    ServerList[ServerTab.TabIndex].AutoRetryTimer.Tag := 0;
    try
      ServerList[ServerTab.TabIndex].Client.Connect(2500);
      if Cmd.Enabled then
        Cmd.SetFocus
      else
        Panel1.SetFocus;
    except
      MemoAppend(ServerTab.TabIndex, ServerList[ServerTab.TabIndex].Memo.Font.Color, '(' + FormatDateTime('hh:mm:ss', now) + ') '
        + 'Connection failed.');

      if IRC.Connected then
        IRC.WriteLn('PRIVMSG ' + Config.IRC.Channel + ' :Connection to ' +
          ServerList[ServerTab.TabIndex].Client.Host + ':' +
          inttostr(ServerList[ServerTab.TabIndex].Client.Port) + ' failed.');

      //  ServerList[ServerTab.TabIndex].Memo.Add(Memo.Lines[Memo.Lines.Count-1]);
      WriteToLog('(' + FormatDateTime('hh:mm:ss', now) + ') ' +
        'Connection failed.', ServerTab.TabIndex);
      WriteToLog('Session Close: ' + FormatDateTime('ddd mmm dd hh:mm:ss yyyy',
        now), ServerTab.TabIndex);
      WriteToLog('', ServerTab.TabIndex);
    end;
  end
  else
  begin
    try
      ServerList[ServerTab.TabIndex].Client.Disconnect;
      ServerList[ServerTab.TabIndex].AutoRetryTimer.Tag := 101;
    except
    end;
    if IRC.Connected then
      IRC.WriteLn('PRIVMSG ' + Config.IRC.Channel + ' :Disconnected from ' +
        ServerList[ServerTab.TabIndex].Client.Host);

    MemoAppend(ServerTab.TabIndex, ServerList[ServerTab.TabIndex].Memo.Font.Color, '(' + FormatDateTime('HH:mm:ss', now) + ') '
      +
      'Disconnected from ' +
      ServerList[ServerTab.TabIndex].Client.Host);
    // ServerList[ServerTab.TabIndex].Memo.Lines.Append{bb}('(' + FormatDateTime('HH:mm:ss',now) + ') ' + 'Disconnected from ' + ServerList[ServerTab.TabIndex].Client.Host);
    // MemoAdd(ServerList[ServerTab.TabIndex].Memo,'(' + FormatDateTime('HH:mm:ss',now) + ') ' + 'Disconnected from ' + ServerList[ServerTab.TabIndex].Client.Host);
     // ServerList[ServerTab.TabIndex].Memo.Add(Memo.Lines[Memo.Lines.Count-1]);
    WriteToLog('(' + FormatDateTime('HH:mm:ss', now) + ') ' +
      'Disconnected from ' +
      ServerList[ServerTab.TabIndex].Client.Host, ServerTab.TabIndex);
    WriteToLog('Session Close: ' + FormatDateTime('ddd mmm dd hh:mm:ss yyyy',
      now), ServerTab.TabIndex);
    WriteToLog('', ServerTab.TabIndex);
    Connect.Caption := 'Connect';
    EnableConnectButtons(true);
    EnableButtons(false);
    PlayerList.Clear;
  end;
end;

procedure TForm1.ClientConnected(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to ServerTab.Tabs.Count - 1 do
    if ((Sender as TidTCPClient).ComponentIndex =
      ServerList[i].Client.ComponentIndex) then
    begin
      ServerList[i].AutoRetryTimer.Enabled := false;

      ServerTab.Repaint;

      try
        (Sender as TidTCPClient).WriteLn(ServerList[i].Pass); //Pass.Text);
        (Sender as TidTCPClient).WriteLn('REFRESHX');
        (Sender as TidTCPClient).WriteLn('/friendlyfire');
        (Sender as TidTCPClient).WriteLn('/bonus');
        (Sender as TidTCPClient).WriteLn('/vote%');
        (Sender as TidTCPClient).WriteLn('/respawntime');
        (Sender as TidTCPClient).WriteLn('/maxrespawntime');
        //   (Sender as TidTCPClient).WriteLn('REFRESH');
        //  ServerList[ServerTab.TabIndex].Client.WriteLn(Pass.Text);
        //  ServerList[ServerTab.TabIndex].Client.WriteLn('REFRESH');

        if ServerList[i].Config.EventOn[2] then
          EventOccure('$SERVER_IP$SERVER_PORT', (Sender as TidTCPClient).Host +
            '' + inttostr((Sender as TidTCPClient).Port),
            ServerList[i].Config.EventFile[2], i);
        //    procedure EventOccure(param, value, scriptfile: string; index: integer);

      except
      end;

      if i = ServerTab.TabIndex then
      begin
        Connect.Caption := 'Disconnect';
        EnableButtons(true);
        EnableConnectButtons(false);
      end;
    end;
end;

procedure TForm1.TimerTimer(Sender: TObject);
var
  Msg, seged, AdminIP: string;
  i, j: shortint;
  kd: double;
  k, movestart: integer;
  TextColor: TColor;
  refreshx270: TMsg_Refreshx_270;
  refreshx265: TMsg_Refreshx_265;
  refreshx264: TMsg_Refreshx_264;
begin
  for j := 0 to ServerTab.Tabs.Count - 1 do
  begin
    TextColor := ServerList[j].Memo.Font.Color;
    if ServerList[j].Client.Connected and not ServerList[j].stopparse then
      // exit;
    begin
      try
        Msg := ServerList[j].Client.ReadLn(#13#10, 5);
        if Matches(ServerList[j].Pass + ' (*.*.*.*)', Msg) and not
          Matches(ServerList[j].Pass + ' (*.*.*.*:*)', Msg) then
          Msg := ''; // don't display adminpassword

        AdminIP := '';
        // old $ replacement thing:   StringReplace(ServerList[j].Client.ReadLn(#13#10,5), '$', '$',  [rfReplaceAll] ); //#13#10,0
      except
        MemoAppend(j, TextColor, '(' + FormatDateTime('HH:mm:ss', now) + ') ' +
          'Connection to the server lost');
        //ServerList[j].Memo.Lines.Append{bb}('(' + FormatDateTime('HH:mm:ss',now) + ') ' + 'Connection to the server lost');
        //MemoAdd(ServerList[j].Memo,'(' + FormatDateTime('HH:mm:ss',now) + ') ' + 'Connection to the server lost');
         //   ServerList[j].Memo.Add(Memo.Lines[Memo.Lines.Count-1]);
        WriteToLog('(' + FormatDateTime('HH:mm:ss', now) + ') ' +
          'Connection to the server lost', j);
        WriteToLog('Session Close: ' +
          FormatDateTime('ddd mmm dd hh:mm:ss yyyy', now), j);
        WriteToLog('', j);
        if j = ServerTab.TabIndex then
        begin
          Connect.Caption := 'Connect';
          EnableConnectButtons(true);
          EnableButtons(false);
          PlayerList.Clear;
        end;
        ServerList[j].Client.Disconnect;
        ServerTab.Tabs[j] := ServerList[j].ServerName;
        Msg := ''; // copy packet fail fix
      end;

      if (Msg <> '') then
      begin

        /////////// ignore (IP) on commands ///////////

        // disabled due to bugs - server ip addition to messages changes a lot ...
        if Matches('* (*.*.*.*)', Msg) and not Matches('* (*.*.*.*:*)', Msg)
          then
        begin
          i := Pos('.', Msg);
          if i > 6 then
          begin
            k := PosEx(' (', Msg, i - 7);
            if k <> 0 then
            begin
                i := k;
                i := PosEx('.', Msg, i + 1);
                i := PosEx('.', Msg, i + 1);
                i := PosEx('.', Msg, i + 1);
                if i <> 0 then
                begin
                  inc(i);
                  while(Msg[i] >= '0') and (Msg[i] <= '9') and (i < Length(Msg)) do
                  begin
                    inc(i);
                  end;
                  if (Msg[i] = ' ') and (i + 1 < Length(Msg)) and
                    (Msg[i + 1] = '[') and (Msg[Length(Msg) - 1] = ']') then
                    i := Length(Msg);
                  AdminIP := Copy(Msg, k, i - k) + ')';
                  Msg := Copy(Msg, 0, k - 1);
                end
            end
          end
        end
        else
          AdminIP := '';

        if Config.PlayersOnTab then
          ServerTab.Tabs[j] := ServerList[j].ServerName + ' (' +
            inttostr(PlayerNum(j)) + ')'
        else if ServerTab.Tabs[j] <> ServerList[j].ServerName then
          ServerTab.Tabs[j] := ServerList[j].ServerName;

        /////// OnData Event ///////////////

        if ServerList[j].Config.EventOn[11] then
          EventOccure('$DATA$SERVER_IP$SERVER_PORT', Msg + '' +
            ServerList[j].Client.Host + '' +
            inttostr(ServerList[j].Client.Port),
            ServerList[j].Config.EventFile[11], j);
        //if Settings1.EventList.Items[11].Checked then EventOccure('$DATA',Msg+'',Settings1.EventList.Items[11].SubItems[0] ,j);

        ///////////// REFRESHX checking ///////////////

        if Matches('Server Version: *.*.*', Msg) and not
          Matches('Server Version: *.*.* (*.*.*.*)', Msg) then
          begin
            // decide which REFRESHX version we should use
            if UpdateThread.VersionCheck('v2.6.9.9', 'v' + Copy(Msg,
              Length('Server Version: ') + 1, Length(Msg) -
              Length('Server Version: ')) + '.0') then
            begin
              MemoAppend(j, TextColor, 'Using REFRESHX v2.7.0');
              ServerList[j].RefreshMsgVers := REFRESHX_270;
            end
            else if UpdateThread.VersionCheck('v2.6.4.9', 'v' + Copy(Msg,
              Length('Server Version: ') + 1, Length(Msg) -
              Length('Server Version: ')) + '.0') then
            begin
              MemoAppend(j, TextColor, 'Using REFRESHX v2.6.5');
              ServerList[j].RefreshMsgVers := REFRESHX_265;
            end
            else
            begin
              MemoAppend(j, TextColor, 'Using REFRESHX v2.6.4');
              ServerList[j].RefreshMsgVers := REFRESHX_264;
            end;
          end;

          ////////// Update maxplayers data /////////////

          if Matches('*Succesfully logged in*', Msg) then
          begin
            //    ServerList[j].Client.WriteLn('/maxplayers');
            if ServerList[j].Config.EventOn[2] then
              EventOccure('$SERVER_IP$SERVER_PORT', ServerList[j].Client.Host +
                '' + inttostr(ServerList[j].Client.Port),
                ServerList[j].Config.EventFile[2], j);
          end;

          if Matches('Max players is *', Msg) then
          begin
            seged := Msg;
            Delete(seged, 1, Length('Max players is '));
            ServerList[j].Maxplayers := seged;
            ServerList[j].Maxplayer := StrToIntDef(seged, 0);
          end;

          if Matches('Friendly Fire is *', Msg) then
          begin
            seged := Msg;
            Delete(seged, 1, Length('Friendly Fire is '));
            if seged = '0' then
              ServerList[j].ff := 'off' // FF.Caption:= 'off'
            else
              ServerList[j].ff := 'on';
          end;

          if Matches('Current bonus frequency is *', Msg) then
          begin
            seged := Msg;
            Delete(seged, 1, Length('Current bonus frequency is '));
            case (strtoint(seged)) of
              0: ServerList[j].bonus := 'off';
              1: ServerList[j].bonus := 'very few';
              2: ServerList[j].bonus := 'few';
              3: ServerList[j].bonus := 'normal';
              4: ServerList[j].bonus := 'much';
              5: ServerList[j].bonus := 'lots';
            end;
          end;

          if Matches('Voting percent is *', Msg) then
          begin
            seged := Msg;
            Delete(seged, 1, Length('Voting percent is '));
            ServerList[j].voting := strtoint(seged);
          end;

          if Matches('Respawn time is *', Msg) then
          begin
            seged := Msg;
            Delete(seged, 1, Length('Respawn time is '));
            Delete(seged, Pos('seconds', seged), Length('seconds'));
            ServerList[j].respawn := seged;
          end;

          if Matches('Maximum Respawn time is * seconds', Msg) then
          begin
            seged := Msg;
            Delete(seged, 1, Length('Maximum Respawn time is '));
            Delete(seged, Pos('seconds', seged), Length('seconds'));
            ServerList[j].respawn := ServerList[j].respawn + ' - ' + seged;
          end;

          if Matches('Max players changed to *', Msg) then
          begin
            seged := Msg;
            Delete(seged, 1, Length('Max players changed to '));
            ServerList[j].Maxplayers := seged;
            ServerList[j].Maxplayer := StrToIntDef(seged, 0);
          end;

          //////////REFRESH//////////////////////////

          if Msg = 'REFRESH' then
          begin
            ServerList[j].Client.ReadBuffer(RefreshMsg,
              sizeof(RefreshMsg));
            Msg := '(there was an old REFRESH request)';
          end;

          if Msg = 'REFRESHX' then
          begin
            ServerList[j].joinedPlayerNicks.Clear();
            if ServerList[j].RefreshMsgVers = REFRESHX_270 then
            begin
              try
              ServerList[j].Client.ReadBuffer(ServerList[j].RefreshMsg,
                sizeof(TMsg_Refreshx_270));
              except
              end;
            end
            else if ServerList[j].RefreshMsgVers = REFRESHX_265 then
            begin
              try
                ServerList[j].Client.ReadBuffer(refreshx265,
                  sizeof(TMsg_Refreshx_265));

                for k := 1 to MAX_PLAYERS do
                begin
                  ServerList[j].RefreshMsg.Name[k] := refreshx265.Name[k];
                  ServerList[j].RefreshMsg.Team[k] := refreshx265.Team[k];
                  ServerList[j].RefreshMsg.Kills[k] := refreshx265.Kills[k];
                  ServerList[j].RefreshMsg.Caps[k] := refreshx265.Caps[k];
                  ServerList[j].RefreshMsg.Deaths[k] := refreshx265.Deaths[k];
                  ServerList[j].RefreshMsg.Ping[k] := refreshx265.Ping[k];
                  ServerList[j].RefreshMsg.Number[k] := refreshx265.Number[k];
                  ServerList[j].RefreshMsg.IP[k][1] := refreshx265.IP[k][1];
                  ServerList[j].RefreshMsg.IP[k][2] := refreshx265.IP[k][2];
                  ServerList[j].RefreshMsg.IP[k][3] := refreshx265.IP[k][3];
                  ServerList[j].RefreshMsg.IP[k][4] := refreshx265.IP[k][4];
                  ServerList[j].RefreshMsg.X[k] := refreshx265.X[k];
                  ServerList[j].RefreshMsg.Y[k] := refreshx265.Y[k];
                end;
                  ServerList[j].RefreshMsg.RedFlagX := refreshx265.RedFlagX;
                  ServerList[j].RefreshMsg.BlueFlagX := refreshx265.BlueFlagX;
                  ServerList[j].RefreshMsg.BlueFlagY := refreshx265.BlueFlagY;
                  ServerList[j].RefreshMsg.TeamScore[1] := refreshx265.TeamScore[1];
                  ServerList[j].RefreshMsg.TeamScore[2] := refreshx265.TeamScore[2];
                  ServerList[j].RefreshMsg.TeamScore[3] := refreshx265.TeamScore[3];
                  ServerList[j].RefreshMsg.TeamScore[4] := refreshx265.TeamScore[4];
                  ServerList[j].RefreshMsg.MapName := refreshx265.MapName;
                  ServerList[j].RefreshMsg.TimeLimit := refreshx265.TimeLimit;
                  ServerList[j].RefreshMsg.CurrentTime := refreshx265.CurrentTime;
                  ServerList[j].RefreshMsg.KillLimit := refreshx265.KillLimit;
                  ServerList[j].RefreshMsg.GameStyle := refreshx265.GameStyle;
                  ServerList[j].RefreshMsg.MaxPlayers := refreshx265.MaxPlayers;
                  ServerList[j].RefreshMsg.MaxSpectators := refreshx265.MaxSpectators;
                  ServerList[j].RefreshMsg.Passworded := refreshx265.Passworded;
                  ServerList[j].RefreshMsg.NextMap := refreshx265.NextMap;
              except
              end;
            end
            else if ServerList[j].RefreshMsgVers = REFRESHX_264 then
            begin
              ServerList[j].Client.ReadBuffer(refreshx264,
                  sizeof(TMsg_Refreshx_264));
              for k := 1 to MAX_PLAYERS do
                begin
                  ServerList[j].RefreshMsg.Name[k] := refreshx264.Name[k];
                  ServerList[j].RefreshMsg.Team[k] := refreshx264.Team[k];
                  ServerList[j].RefreshMsg.Kills[k] := refreshx264.Kills[k];
                  ServerList[j].RefreshMsg.Deaths[k] := refreshx264.Deaths[k];
                  ServerList[j].RefreshMsg.Ping[k] := refreshx264.Ping[k];
                  ServerList[j].RefreshMsg.Number[k] := refreshx264.Number[k];
                  ServerList[j].RefreshMsg.IP[k][1] := refreshx264.IP[k][1];
                  ServerList[j].RefreshMsg.IP[k][2] := refreshx264.IP[k][2];
                  ServerList[j].RefreshMsg.IP[k][3] := refreshx264.IP[k][3];
                  ServerList[j].RefreshMsg.IP[k][4] := refreshx264.IP[k][4];
                  ServerList[j].RefreshMsg.X[k] := refreshx264.X[k];
                  ServerList[j].RefreshMsg.Y[k] := refreshx264.Y[k];
                end;
                  ServerList[j].RefreshMsg.RedFlagX := refreshx264.RedFlagX;
                  ServerList[j].RefreshMsg.RedFlagY := refreshx264.RedFlagY;
                  ServerList[j].RefreshMsg.BlueFlagX := refreshx264.BlueFlagX;
                  ServerList[j].RefreshMsg.BlueFlagY := refreshx264.BlueFlagY;
                  ServerList[j].RefreshMsg.TeamScore[1] := refreshx264.TeamScore[1];
                  ServerList[j].RefreshMsg.TeamScore[2] := refreshx264.TeamScore[2];
                  ServerList[j].RefreshMsg.TeamScore[3] := refreshx264.TeamScore[3];
                  ServerList[j].RefreshMsg.TeamScore[4] := refreshx264.TeamScore[4];
                  ServerList[j].RefreshMsg.MapName := refreshx264.MapName;
                  ServerList[j].RefreshMsg.TimeLimit := refreshx264.TimeLimit;
                  ServerList[j].RefreshMsg.CurrentTime := refreshx264.CurrentTime;
                  ServerList[j].RefreshMsg.KillLimit := refreshx264.KillLimit;
                  ServerList[j].RefreshMsg.GameStyle := refreshx264.GameStyle;
                  ServerList[j].RefreshMsg.MaxPlayers := refreshx264.MaxPlayers;
                  ServerList[j].RefreshMsg.MaxSpectators := refreshx264.MaxSpectators;
                  ServerList[j].RefreshMsg.Passworded := refreshx264.Passworded;
                  ServerList[j].RefreshMsg.NextMap := refreshx264.NextMap;
            end;
            FixNames(j);
            //     ServerList[j].Memo.Lines.Add('refreshed hopefully');
            if j = ServerTab.TabIndex then
              DoRefresh();

            if ServerList[j].Config.EventOn[12] then
              EventOccure('$SERVER_IP$SERVER_PORT', ServerList[j].Client.Host +
                '' + inttostr(ServerList[j].Client.Port),
                ServerList[j].Config.EventFile[12], j);

            {     ServerList[j].Memo.Lines.Add('MaxPlayers: '+inttostr(ServerList[j].RefreshMsg.MaxPlayers));
                 ServerList[j].Memo.Lines.Add('MaxSpectators: '+inttostr(ServerList[j].RefreshMsg.MaxSpectators));
                 ServerList[j].Memo.Lines.Add('Passworded: '+inttostr(ServerList[j].RefreshMsg.Passworded));
                 ServerList[j].Memo.Lines.Add('Next Map: '+ ServerList[j].RefreshMsg.NextMap );

                 ServerList[j].Memo.Lines.Add('Red Flag: '+ floattostr(ServerList[j].RefreshMsg.RedFlagX) +','+ floattostr(ServerList[j].RefreshMsg.RedFlagY) );
            }

            //     ServerList[j].Memo.Lines.Add(inttostr( ServerList[j].RefreshMsg.Ping[1] ));
            ServerList[j].MaxPlayer := ServerList[j].RefreshMsg.MaxPlayers; //0;
            ServerList[j].Maxplayers :=
              inttostr(ServerList[j].RefreshMsg.MaxPlayers);
            ServerList[j].Teams[1] := 0;
            ServerList[j].Teams[2] := 0;
            ServerList[j].Teams[3] := 0;
            ServerList[j].Teams[4] := 0;
            i := 1;
            //if (ServerList[j].RefreshMsg.Team[i] > 6) then
              //inc(ServerList[j].MaxPlayer);
            repeat
              case ServerList[j].RefreshMsg.Team[i] of
                1: inc(ServerList[j].Teams[1]);
                2: inc(ServerList[j].Teams[2]);
                3: inc(ServerList[j].Teams[3]);
                4: inc(ServerList[j].Teams[4]);
              end;
              inc(i);
            until (i = MAX_PLAYERS) or (ServerList[j].RefreshMsg.Team[i] > 6);
            exit;
          end;

          //////////END of REFRESH//////////////////////////

          ///////// Successfuly connected ////////////////

          if Matches('Succesfully logged in.', Msg) and IRC.Connected then
            try
              IRC.WriteLn('PRIVMSG ' + Config.IRC.Channel + ' :Connected to ' +
                ServerList[j].Client.Host + ':' +
                inttostr(ServerList[j].Client.Port));
            except
            end;

          Msg := '(' + FormatDateTime('HH:mm:ss', now) + ') ' + Msg;
          selpos[j] := ServerList[j].Memo.SelStart;
          sellen[j] := ServerList[j].Memo.sellength;

          ////////// Swap Teams ///////////////

          if (ServerList[j].Config.autoswap and Matches('(??:??:??) Next map:*',
            Msg)) then
            ServerList[j].SwapTimer.Enabled := true; //SwapTeams(0,j);

          ////////// Balance Teams ////////////

          if ServerList[j].Config.autobalance then
          begin
            current_server := j;
            BalanceTimer.Interval := Timer.Interval + 2000;
            BalanceTimer.Enabled := true;
            {    i:=1;
                a:=0;
                b:=0;
                repeat
                 case ServerList[j].RefreshMsg.Team[i] of
                   1: inc(a);
                   2: inc(b);
                 end;
                 inc(i);
                until (i=MAX_PLAYERS) or (ServerList[j].RefreshMsg.Team[i]>6);
                if ((a+Config.balancediff)<=b) or ((b+Config.balancediff)<=a) then
                    ServerList[j].Client.WriteLn('/balance'); //BalanceTeams(j);
               }
          end;

          ////////// Adminlist //////////////

          if Matches('(??:??:??) /clientlist', Msg) then
          begin
            ServerList[j].Client.WriteLn('[�] ' + Config.AdminName + ': ARSSE '
              +
              VERSION + '.' + VERSIONBUILD + ' ' + VERSIONSTATUS);
          end;

          //////// OnPlayerSay //////////////

          //Memo.SelAttributes.Color := clLime;
          //TextColor := clLime;
          if Matches('(??:??:??) [�]*:*', Msg) then
          begin
            //ServerList[j].Memo.SelAttributes.Color := Config.ColorClientList;
            TextColor := Config.ColorClientList;
          end
          else if Matches('(??:??:??) [*]*', Msg) then
          begin
            //    for i:=1 to MAX_PLAYERS do
            i := 1;
            repeat
              if Matches('(??:??:??) [' + ServerList[j].RefreshMsg.Name[i] +
                ']*', Msg) then
              begin
                if ServerList[j].Config.EventOn[7] then
                begin
                  if ServerList[j].RefreshMsg.Deaths[i] <> 0 then
                    kd := ServerList[j].RefreshMsg.Kills[i] /
                      ServerList[j].RefreshMsg.Deaths[i]
                  else
                    kd := 0;

                  {
                         Bontott:= TStringList.Create;
                         Bontott.Delimiter:= ' ';
                         Bontott.DelimitedText:= Copy(Msg,Length('(??:??:??) ['+ ServerList[j].RefreshMsg.Name[i] +'] ')+1,Length(Msg)-Length('(??:??:??) ['+ ServerList[j].RefreshMsg.Name[i] +'] '));
                         for k:= 0 to Bontott.Count-1 do
                           seged:=seged+'$$'+inttostr(k+1)+'';
                  }
                  //       Bontott.Delimiter:= '';

                  //StringReplace(ServerList[j].Client.ReadLn(#13#10,5), '$', '&',  [rfReplaceAll] )

                  EventOccure('$MESSAGE$PLAYER_NAME$PLAYER_NUM$PLAYER_SCORE$PLAYER_DEATHS$PLAYER_RATE$PLAYER_PING$PLAYER_TEAM$PLAYER_IP$SERVER_IP$SERVER_PORT$TEAMCHAT',
                    StringReplace(Copy(Msg, Length('(??:??:??) [' +
                    ServerList[j].RefreshMsg.Name[i] + '] ') + 1, Length(Msg) -
                    Length('(??:??:??) [' + ServerList[j].RefreshMsg.Name[i] +
                    '] ')), '$', '&', [rfReplaceAll]) + '' +
                    ServerList[j].RefreshMsg.Name[i] + '' +
                    inttostr(ServerList[j].RefreshMsg.Number[i]) + '' +
                    inttostr(ServerList[j].RefreshMsg.Kills[i]) + '' +
                    inttostr(ServerList[j].RefreshMsg.Deaths[i]) + '' +
                    formatfloat('0.00', kd) + '' +
                    inttostr(ServerList[j].RefreshMsg.Ping[i]) + '' +
                    inttostr(ServerList[j].RefreshMsg.Team[i]) + '' +
                    inttostr(ServerList[j].RefreshMsg.IP[i][1]) + '.' +
                    inttostr(ServerList[j].RefreshMsg.IP[i][2]) + '.' +
                    inttostr(ServerList[j].RefreshMsg.IP[i][3]) + '.' +
                    inttostr(ServerList[j].RefreshMsg.IP[i][4]) + '' +
                    ServerList[j].Client.Host + '' +
                    inttostr(ServerList[j].Client.Port) + 'false',
                    ServerList[j].Config.EventFile[7], j);

                  //       ShowMessage(Bontott.DelimitedText);
                  //       ShowMessage(seged);

                  //       Bontott.Free;

                end;

                //ServerList[j].Memo.SelAttributes.Color := Config.ColorChat;
                TextColor := Config.ColorChat;
                // clAqua;
              //      seged:= Msg;
              //      Delete(seged,1,Length('(??:??:??) ['+ ServerList[j].RefreshMsg.Name[i] +'] '));

              end;
              inc(i);
            until (i = MAX_PLAYERS) or (ServerList[j].RefreshMsg.Team[i] > 6);
            if TextColor <> Config.ColorChat then
            begin
              for i := 0 to ServerList[j].joinedPlayerNicks.Count - 1 do
              begin
                if Matches('(??:??:??) [' + ServerList[j].joinedPlayerNicks[i] +']*', Msg) then
                begin
                  TextColor := Config.ColorChat;
                  // TODO make event occur for chat message
                  Break;
                end;
              end;
            end;
          end
          else if Matches('(??:??:??) /say *', Msg) or
            Matches('(??:??:??) /pm *',
            Msg) then
          begin
            //if j = ServerTab.TabIndex then
            if Matches('(??:??:??) /say *', Msg) then
            begin
              //ServerList[j].Memo.SelAttributes.Color := Config.ColorAdmin;
              TextColor := Config.ColorAdmin;
            end;
            if Matches('(??:??:??) /pm *', Msg) then
            begin
              //ServerList[j].Memo.SelAttributes.Color := Config.ColorPm;
              TextColor := Config.ColorPm;
            end;
            Msg := '2' + Msg;
          end
          // else if Matches('(??:??:??) * captured the Blue Flag',Msg) or
          //   Matches('(??:??:??) * returned the Red Flag',Msg) or
          //   Matches('(??:??:??) * scores for Alpha Team',Msg) then
          //   Memo.SelAttributes.Color:= clRed
          //   TextColor := clRed
          else
          // Memo.SelAttributes.Color:= clLime;
          // TextColor := clLime;
            ;

          ///////// On Player Team Chat //////////

          if Matches('(??:??:??) (TEAM)[*] *', Msg) then
          begin
            for i := 1 to MAX_PLAYERS do
              if Matches('(??:??:??) (TEAM)[' + ServerList[j].RefreshMsg.Name[i]
                +
                '] *', Msg) then
              begin
                if ServerList[j].Config.EventOn[7] then
                begin
                  if ServerList[j].RefreshMsg.Deaths[i] <> 0 then
                    kd := ServerList[j].RefreshMsg.Kills[i] /
                      ServerList[j].RefreshMsg.Deaths[i]
                  else
                    kd := 0;
                  EventOccure('$MESSAGE$PLAYER_NAME$PLAYER_NUM$PLAYER_SCORE$PLAYER_DEATHS$PLAYER_RATE$PLAYER_PING$PLAYER_TEAM$PLAYER_IP$SERVER_IP$SERVER_PORT$TEAMCHAT',
                    StringReplace(Copy(Msg, Length('(??:??:??) (TEAM)[' +
                    ServerList[j].RefreshMsg.Name[i] + '] ') + 1,
                    Length(Msg) - Length('(??:??:??) (TEAM)[' +
                    ServerList[j].RefreshMsg.Name[i] + '] ')), '$', '&',
                    [rfReplaceAll]) + '' + ServerList[j].RefreshMsg.Name[i] +
                      ''
                    + inttostr(ServerList[j].RefreshMsg.Number[i])
                    + '' + inttostr(ServerList[j].RefreshMsg.Kills[i]) + '' +
                    inttostr(ServerList[j].RefreshMsg.Deaths[i]) + ''
                    + floattostr(kd) + '' +
                    inttostr(ServerList[j].RefreshMsg.Ping[i]) + '' +
                    inttostr(ServerList[j].RefreshMsg.Team[i]) + '' +
                    inttostr(ServerList[j].RefreshMsg.IP[i][1]) + '.' +
                    inttostr(ServerList[j].RefreshMsg.IP[i][2]) + '.' +
                    inttostr(ServerList[j].RefreshMsg.IP[i][3]) + '.' +
                    inttostr(ServerList[j].RefreshMsg.IP[i][4]) + '' +
                    ServerList[j].Client.Host + '' +
                    inttostr(ServerList[j].Client.Port) + 'true',
                    ServerList[j].Config.EventFile[7], j);
                end;
              end;
            // ServerList[j].Memo.SelAttributes.Color := Config.ColorTeam;
            TextColor := Config.ColorTeam;
            // clSkyBlue;
          end;

          ///////// On Player Team Chat //////////

          if Matches('(??:??:??) (RADIO)[*] *', Msg) then
          begin
            for i := 1 to MAX_PLAYERS do
              if Matches('(??:??:??) (RADIO)[' + ServerList[j].RefreshMsg.Name[i]
                +
                '] *', Msg) then
              begin
                if ServerList[j].Config.EventOn[7] then
                begin
                  if ServerList[j].RefreshMsg.Deaths[i] <> 0 then
                    kd := ServerList[j].RefreshMsg.Kills[i] /
                      ServerList[j].RefreshMsg.Deaths[i]
                  else
                    kd := 0;
                  EventOccure('$MESSAGE$PLAYER_NAME$PLAYER_NUM$PLAYER_SCORE$PLAYER_DEATHS$PLAYER_RATE$PLAYER_PING$PLAYER_TEAM$PLAYER_IP$SERVER_IP$SERVER_PORT$TEAMCHAT',
                    StringReplace(Copy(Msg, Length('(??:??:??) (RADIO)[' +
                    ServerList[j].RefreshMsg.Name[i] + '] ') + 1,
                    Length(Msg) - Length('(??:??:??) (RADIO)[' +
                    ServerList[j].RefreshMsg.Name[i] + '] ')), '$', '&',
                    [rfReplaceAll]) + '' + ServerList[j].RefreshMsg.Name[i] +
                      ''
                    + inttostr(ServerList[j].RefreshMsg.Number[i])
                    + '' + inttostr(ServerList[j].RefreshMsg.Kills[i]) + '' +
                    inttostr(ServerList[j].RefreshMsg.Deaths[i]) + ''
                    + floattostr(kd) + '' +
                    inttostr(ServerList[j].RefreshMsg.Ping[i]) + '' +
                    inttostr(ServerList[j].RefreshMsg.Team[i]) + '' +
                    inttostr(ServerList[j].RefreshMsg.IP[i][1]) + '.' +
                    inttostr(ServerList[j].RefreshMsg.IP[i][2]) + '.' +
                    inttostr(ServerList[j].RefreshMsg.IP[i][3]) + '.' +
                    inttostr(ServerList[j].RefreshMsg.IP[i][4]) + '' +
                    ServerList[j].Client.Host + '' +
                    inttostr(ServerList[j].Client.Port) + 'true',
                    ServerList[j].Config.EventFile[7], j);
                end;
              end;
            // ServerList[j].Memo.SelAttributes.Color := Config.ColorTeam;
            TextColor := Config.ColorTeam;
            // clSkyBlue;
          end;

          ///////// On MUTED Chat //////////

          if Matches('(??:??:??) (MUTED) [*] *', Msg) then
          begin
            // ServerList[j].Memo.SelAttributes.Color := Config.ColorMuted;
            TextColor := Config.ColorMuted;
            // clSilver;
          end;

          /////////// Custom Colors ////////////

          for i := 0 to Config.CustomColors.Count - 1 do
            if Matches('(??:??:??) ' + Config.CustomColors.Names[i], Msg) then
              try
                if Matches('cl*', Config.CustomColors.ValueFromIndex[i]) or
                  Matches('$????????',
                  Config.CustomColors.ValueFromIndex[i]) then
                begin
                  // ServerList[j].Memo.SelAttributes.Color :=
                  // StringToColor(Config.CustomColors.ValueFromIndex[i]);
                    TextColor := StringToColor(Config.CustomColors.ValueFromIndex[i]);
                end;
              except
              end;

          ///////// TeamKill Count ///////////

          if Matches('(??:??:??) (?) * killed (?) * with *', Msg) then
          begin
            ParseKills(Msg, j);
          end;

          //////// On Admin Say //////////////

          if Matches('(??:??:??)  <*> *', Msg) then
          begin
            //    Memo.Lines.Add('admin say');
            //    seged:= Msg;
            //    Delete(Msg,12,1);
            //    col:=clYellow;
            // ServerList[j].Memo.SelAttributes.Color := Config.ColorAdmChat;
            TextColor := Config.ColorAdmChat;
            // clYellow;
          end;
          // else
          // begin
          //  Memo.SelAttributes.Color:= clLime;
          //  TextColor := clLime;
          // end;

          ///////// Write to Memo ///////////////

          if not (ServerList[j].Config.hideRegistered and
            (Matches('(??:??:??) Registering server @ *', Msg) or
            Matches('(??:??:??) Game server added to lobby server @ *', Msg)))
          and not (ServerList[j].Config.hideKills and
            Matches('(??:??:??) (?) * killed (?) * with *', Msg)) then
          begin

            try

              if Matches('?(??:??:??)*', Msg) then
                Delete(Msg, 1, 2);
              if mutathatod then
                // MemoAddColor(ServerList[j].Memo,Msg,startpos,col)
                MemoAppend(j, TextColor, Msg + AdminIP)
                // ServerList[j].Memo.Lines.Append(Msg+AdminIP)
              else
                mutathatod := true;
              // ServerList[j].Memo.SelAttributes.Color :=
              //   ServerList[j].Memo.Font.Color;
              // TextColor := ServerList[j].Memo.Font.Color;
              PostMessage(Handle, WM_MYMEMO_ENTER, 0, 0);

            except
            end;
            if logolhatsz then
              WriteToLog(Msg, j)
            else
              logolhatsz := true;
          end;

          //////// Invalid password //////////////

          if Msg = 'Invalid server password. Cannot login.' then
          begin
            Connect.Caption := 'Connect';
            EnableButtons(false);
            EnableConnectButtons(true);
            try
              ServerList[j].Client.Disconnect;
            except
            end;
            exit;
          end;

          ///////// IP added to remote admins ////////

          if Matches('(??:??:??) IP number * added to Remote Admins', Msg) then
          begin
            Delete(Msg, 1, Length('(??:??:??) IP number '));
            Delete(Msg, Pos(' added', Msg), Length(Msg));

          end;

          ///////// IP removed from remote admins ////////

          if Matches('(??:??:??) IP number * removed from Remote Admins', Msg)
            then
          begin
            Delete(Msg, 1, Length('(??:??:??) IP number '));
            Delete(Msg, Pos(' removed', Msg), Length(Msg));
          end;

          //////// On Admin Connect /////////

          if ServerList[j].Config.EventOn[8] then
          begin

            ////// successfuly connected /////////
            if Matches('(??:??:??) Admin connected*', Msg) then
            begin
              //    Delete(Msg,1,11);
              Delete(Msg, 1, Length('(??:??:??) Admin connected '));
              if Matches('(*).', Msg) then
                Msg := Copy(Msg, 2, Length(Msg) - 3)
              else
                Msg := 'Old Server :(';
              EventOccure('$ADMIN_IP$SERVER_IP$SERVER_PORT$LOGIN_SUCCESS', Msg
                +
                '' + ServerList[j].Client.Host + '' +
                inttostr(ServerList[j].Client.Port) + 'true',
                ServerList[j].Config.EventFile[8], j);
            end;

            ///// failed to connect //////////
            if Matches('(??:??:??) Admin failed to connect *', Msg) then
            begin
              Delete(Msg, 1, Length('(??:??:??) Admin failed to connect '));
              if Matches('(*).', Msg) then
                Msg := Copy(Msg, 2, Length(Msg) - 3)
              else
                Msg := 'Old Server :(';
              EventOccure('$ADMIN_IP$SERVER_IP$SERVER_PORT$LOGIN_SUCCESS', Msg
                +
                '' + ServerList[j].Client.Host + '' +
                inttostr(ServerList[j].Client.Port) + 'false',
                ServerList[j].Config.EventFile[8], j);
            end;

          end;

          //////// On Admin Disconnect /////////

          if Matches('(??:??:??) Admin disconnected*', Msg) and
          ServerList[j].Config.EventOn[9] then
          begin
            EventOccure('$SERVER_IP$SERVER_PORT', Msg + '' + seged + '' +
              ServerList[j].Client.Host + '' +
              inttostr(ServerList[j].Client.Port),
              ServerList[j].Config.EventFile[9], j);
          end;

          //////// On Time Left /////////

          if Matches('(??:??:??) Time Left: * minutes', Msg) and
          ServerList[j].Config.EventOn[10] then
          begin
            Delete(Msg, 1, Length('(??:??:??) Time Left: '));
            Delete(Msg, Pos(' minutes', Msg), Length(' minutes'));
            EventOccure('$TIME_LEFT$SERVER_IP$SERVER_PORT', Msg + '' + seged
              +
              '' + ServerList[j].Client.Host + '' +
              inttostr(ServerList[j].Client.Port),
              ServerList[j].Config.EventFile[10], j);
          end;

          //////// On Join Request /////////

          if Matches('(??:??:??) *:* requesting game...', Msg) and
          ServerList[j].Config.EventOn[4] then
          begin
            Delete(Msg, 1, 11);
            Delete(Msg, Length(Msg) - Length(' requesting game...') + 1,
              Length(' requesting game...'));
            seged := Copy(Msg, Pos(':', Msg) + 1, Length(Msg) - Pos(':', Msg));
            Delete(Msg, Pos(':', Msg), Length(Msg));
            EventOccure('$PLAYER_IP$PLAYER_PORT$SERVER_IP$SERVER_PORT', Msg +
              '' + seged + '' + ServerList[j].Client.Host +
              '' + inttostr(ServerList[j].Client.Port),
              ServerList[j].Config.EventFile[4], j);
          end;

          //////// On Player Leave /////////

          if Matches('(??:??:??) * has left * team.', Msg) and
          ServerList[j].Config.EventOn[6] then
          begin
            Delete(Msg, 1, 11);
            Delete(Msg, Length(Msg) - Length(Copy(Msg, Pos(' has left', Msg),
              Length(Msg))) + 1, Length(Msg));
            EventOccure('$PLAYER_NAME$SERVER_IP$SERVER_PORT', Msg + '' +
              ServerList[j].Client.Host + '' +
              inttostr(ServerList[j].Client.Port),
              ServerList[j].Config.EventFile[6], j);
            ServerList[j].Client.WriteLn('REFRESHX');
          end;

          if Matches('(??:??:??) * has left the game.', Msg) and
          ServerList[j].Config.EventOn[6] then
          begin
            Delete(Msg, 1, 11);
            Delete(Msg, Length(Msg) - Length(' has left the game.') + 1,
              Length(' has left the game.'));
            EventOccure('$PLAYER_NAME$SERVER_IP$SERVER_PORT', Msg + '' +
              ServerList[j].Client.Host + '' +
              inttostr(ServerList[j].Client.Port),
              ServerList[j].Config.EventFile[6], j);
            //    if Config.autobalance then BalanceTeams(j);
          end;

          //////// On Player Join ////////////
          //(17:56:23) ::RiA::KeFear joining game (81.183.175.243:23083) (??:??:??)

       //   ServerList[j].Memo.Lines.Add('debug: '+Msg);
          if Matches('(??:??:??) * joining game (*:*)', Msg) then
          begin
            Delete(Msg, 1, 11);
            seged := Msg;
            Delete(Msg, Pos('joining game', Msg), Length(Msg) -
              Pos('joining game', Msg) + 1);
            while Msg[Length(Msg)] = ' ' do
              Delete(Msg, Length(Msg), 1);

            Delete(seged, 1, Length(Msg));
            Delete(seged, 1, Length(' joining game ('));
            Delete(seged, Pos(':', seged), Length(seged) - Pos(':', seged));
            Delete(seged, Pos(')', seged), 1);

            //    ServerList[j].Memo.Lines.Add(Msg+' '+seged);

            OnPlayerJoin(Msg, seged, j);
            ServerList[j].joinedPlayerNicks.Add(Msg);
            //    ShowMessage(Msg+' :: '+ seged);
            //    if Config.autobalance then BalanceTeams(j);
          end;

          //////////// VARIOUS EVENTS REQUIRING REFRESH //////////////

          if Matches('(??:??:??) * has joined * team.', Msg) then
          begin
            ServerList[j].Client.WriteLn('REFRESHX');
          end;
          if Matches('(??:??:??) * has left * team.', Msg) then
          begin
            ServerList[j].Client.WriteLn('REFRESHX');
          end;
          if Matches('(??:??:??) * has joined the game.', Msg) then
          begin
            ServerList[j].Client.WriteLn('REFRESHX');
          end;
          if Matches('(??:??:??) * has left the game.', Msg) then
          begin
            ServerList[j].Client.WriteLn('REFRESHX');           
          end;
          if Matches('(??:??:??) * has been kicked*', Msg) then
          begin
            // removing bots from playerslist if possible (unfinished)
            // for i := 1 to MAX_PLAYERS do
            // begin
            //   if ServerList[j].RefreshMsg.Name[i] = Copy(Msg, 12, Pos(' has been kicked', Msg) - 12) then
            //     break;
            // end;
          end;
          if Matches('(??:??:??) * scores for * team', Msg) then
          begin
            ServerList[j].Client.WriteLn('REFRESHX');
          end;
          if Matches('(??:??:??) (*) * killed (*) * with *', Msg) then
          begin
            ServerList[j].Client.WriteLn('REFRESHX');
          end;
          if Matches('(??:??:??) * has joined as spectator.', Msg) then
          begin
            ServerList[j].Client.WriteLn('REFRESHX');
          end;
          if Matches('(??:??:??) * has joined spectators', Msg) then
          begin
            ServerList[j].Client.WriteLn('REFRESHX');
          end;
          if Matches('(??:??:??) * has left spectators', Msg) then
          begin
            ServerList[j].Client.WriteLn('REFRESHX');
          end;

          /////////// BANNAME COMMAND /////////

          if Matches('(??:??:??) /banname *', Msg) then
          begin
            Delete(Msg, 1, 20);
            AddToBanList(Msg, true);
          end;

          // next wildcard ban feature (need to add to menu too)
          {if Matches('(??:??:??) /bannameex *', Msg) then
          begin
            Delete(Msg, 1, 22);
            AddToWildBanList(Msg, true);
          end;}

          /////////// UNBANNAME COMMAND /////////

          if Matches('(??:??:??) /unbanname *', Msg) then
          begin
            Delete(Msg, 1, 22);
            AddToBanList(Msg, false);
          end;

          {if Matches('(??:??:??) /unbannameex *', Msg) then
          begin
            Delete(Msg, 1, 24);
            AddToWildBanList(Msg, false);
          end;}

          /////////// MUTEBUG COMMAND /////////

          if Matches('(??:??:??) /mutebug *', Msg) then
          begin
            Delete(Msg, 1, 20);
            //    MuteBug(Msg,);
          end;

          /////////// end of msg ////////////
          ServerList[j].Memo.SelStart := selpos[j];
          ServerList[j].Memo.sellength := sellen[j];
      end;
    end;
  end;
end;

procedure TForm1.ClientDisconnected(Sender: TObject);
var
  i: integer;
begin
  try
    for i := 0 to ServerTab.Tabs.Count - 1 do
      if ((Sender as TidTCPClient).ComponentIndex =
        ServerList[i].Client.ComponentIndex) then
        //.Host = ServerList[i].Client.Host) and ((Sender as TidTCPClient).Port = ServerList[i].Client.Port) then
        //  if ((Sender as TidTCPClient).Host = ServerList[i].Client.Host) and ((Sender as TidTCPClient).Port = ServerList[i].Client.Port) then

      begin
        ServerTab.Tabs[i] := ServerList[i].ServerName;
        if ServerList[i].Config.EventOn[3] then
          EventOccure('$SERVER_IP$SERVER_PORT', (Sender as TIdTCPClient).Host +
            '' + inttostr((Sender as TIdTCPClient).Port),
            ServerList[i].Config.EventFile[3], i);
        if ServerList[i].AutoRetry then
        begin
          ServerList[i].AutoRetryTimer.Enabled := true;
          break;
        end;
      end;

    if ((Sender as TidTCPClient).ComponentIndex =
      ServerList[ServerTab.TabIndex].Client.ComponentIndex) then
      //.Host = ServerList[i].Client.Host) and ((Sender as TidTCPClient).Port = ServerList[i].Client.Port) then
      // if ((Sender as TidTCPClient).Host = ServerList[ServerTab.TabIndex].Client.Host) and ((Sender as TidTCPClient).Port = ServerList[ServerTab.TabIndex].Client.Port) then
    begin
      if (PageControl.ActivePage = ServerConsole) and (Self.visible) then
        Connect.SetFocus;
      MapName.Caption := '';
      GameMode.Caption := '';
      Limit.Caption := '';
      Time.Caption := '';
      TimeLeft.Caption := '';
      PlayerCount.Caption := '';
      for i := 1 to 6 do
      begin
        TeamList.Items[i - 1].SubItems[0] := '';
        TeamList.Items[i - 1].SubItems[1] := '';
      end;
      AvgPing.Caption := '?';
      TotalScore.Caption := '?';
      TotalDeaths.Caption := '?';
    end;
  except
  end;

  ServerTab.Repaint;

end;

procedure TForm1.ARSSECommands(Msg: string; Index: integer);
var
  serverids: string;
  idlist: TStringList;
  i, id: integer;
begin
  if Matches('/swapteams', Msg) then
    ServerList[ServerTab.TabIndex].SwapTimer.Enabled := true; //SwapTeams(0,j);

  ////////// Skillbalance Teams /////////

  if Matches('/skillbalance', Msg) then
    SwapTeams(1, Index);

  ////////// Balance Teams ////////////

  if Matches('/balance', Msg) then
    BalanceTeams(Index);

  //////// KICKALL COMMAND ////////////

  if Matches('/kickall*', Msg) then
  begin
    Kickall('/kick', Index);
    // disabled due security problem when using nick "/kickall"
    if Length(Msg) > Length('(??:??:??) /kickall ') then
      ServerList[Index].Client.WriteLn('/password ' + Copy(Msg, 20,
        Length(Msg)));
  end;

  //////// SPECTALL COMMAND ////////////

  if Matches('/spectall', Msg) then
    Kickall('/setteam5', Index);

  if Matches('/setteamall ?', Msg) then
  begin
    //if length(Cmd.Text)=13 then
    //begin
    Delete(Msg, 1, 12);
    if (Msg[1] >= '0') and (Msg[1] <= '5') then
      Kickall('/setteam' + Msg, index);
    //end;
  end;

  //////// LOAD SCRIPT Command //////////////

  if Matches('/load *', Msg) then
  begin
    Delete(Msg, 1, 6);
    //LoadScript(Msg,j);
    EventOccure('', '', 'script\' + Msg + '.txt', Index);
  end;

  //////// AMSG Command //////////////
  // syntax: /amsg [<id1,id2,...,idn>] <command>

  if Matches('/amsg *', Msg) then
  begin
    Delete(Msg, 1, 6); // remove '/amsg '
    serverids := copy(Msg, 1, AnsiPos(' ', Msg) - 1); // get possible ids
    // check if id or not
    if (Length(serverids) > 0) and (serverids[1] >= '1') and (serverids[1] <=
      '9') and (serverids[Length(serverids)] >= '0') and
      (serverids[Length(serverids)] <= '9') then
    begin
      Delete(Msg, 1, AnsiPos(' ', Msg)); // get command
      idlist := TStringList.Create();
      idlist.Delimiter := ',';
      idlist.DelimitedText := serverids;
      for i := 0 to idlist.Count - 1 do // send the command for every id
      begin
        id := StrToIntDef(idlist[i], -1) - 1;
        if (id >= 0) and Assigned(@ServerList[id]) and
          (ServerList[id].Client.Connected = true) then
        begin
          ServerList[id].Client.WriteLn(Msg);
          ARSSECommands(Msg, i);
        end;
      end;
    end
    else  // if Length(serverids) > 0 then
    begin
      for i := 0 to 99 do  // ServerList has 100 elements max
        if (Assigned(@ServerList[i])) and (ServerList[i].Client <> nil) and
          (ServerList[i].Client.Connected) then
        begin
          ServerList[i].Client.WriteLn(Msg);
          // showmessage('g' + Msg + 'g');
          ARSSECommands(Msg, i);
        end;
    end;
  end;
end;

procedure TForm1.CmdKeyPress(Sender: TObject; var Key: Char);
var
  Msg, S: string;
begin
  if (Key = #1) and (Ctrl) then  // ctrl+a fix
  begin
    if not SelectAll then
    begin
      if AdminBox.Checked then
        Cmd.SelStart := Length(' ')
      else if SayBox.Checked then
        Cmd.SelStart := Length('/say ')
      else if NickSayBox.Checked then
        Cmd.SelStart := Length('/say [' + Config.AdminName + '] ')
      else
        Cmd.SelStart := 0;
      Cmd.SelLength := Length(Cmd.Text);
      SelectAll := True;
    end
    else
      SelectAll := False;
  end
  else
    SelectAll := False;
  if (Key < #31) and (Key >= #0) and (Key <> #3) and (Key <> #22) and (Key <>
    #24) and Ctrl then //disable beep sound on hotkey
    Key := #0;

  if Key = #13 then //enter has been pressed
  begin
    //  RefreshClick(nil);
    Key := #0;
    //  seged:= Cmd.Text;
    //  if Config.adminname = '' then Config.adminname:= 'Noname-Admin';
    //  if (not Matches('/*', seged)) and (Config.useadminname) { and (Config.adminname <> '') } then seged:= '�<' + Config.adminname + '> ' + seged;
    S := Cmd.Text;
    Msg := Cmd.Text;

    if Matches(' *', Cmd.Text) then
      Cmd.Text := ' <' + Config.AdminName + '>' + Cmd.Text;
    try
      if ServerList[ServerTab.TabIndex].Client.Connected then
      begin
        ServerList[ServerTab.TabIndex].Client.WriteLn(Cmd.Text);
        ARSSECommands(Cmd.Text, ServerTab.TabIndex);
      end
      else
      begin
        MemoAppend(ServerTab.TabIndex, ServerList[ServerTab.TabIndex].Memo.Font.Color, '(' + FormatDateTime('HH:mm:ss', now) +
          ') ' + Cmd.Text);
        //ServerList[ServerTab.TabIndex].Memo.Lines.Append{bb}('(' + FormatDateTime('HH:mm:ss',now) + ') ' + Cmd.Text);
        //MemoAdd(ServerList[ServerTab.TabIndex].Memo,'(' + FormatDateTime('HH:mm:ss',now) + ') ' + Cmd.Text);
      end;
      //ServerList[ServerTab.TabIndex].Memo.Add(Memo.Lines[Memo.Lines.Count-1]);
   //  WriteToLog('(' + FormatDateTime('HH:mm:ss',now) + ') ' + Cmd.Text);
   //  LastCmd:= Cmd.Text;

      //fix admin chat command-add bug
      if S <> '' then
        Cmd.Text := S;

      //add command to list
      if (Cmd.Items[Cmd.Items.Count - 1] <> Cmd.Text) and (Cmd.Text <> '') then
        Cmd.Items.Insert(0, Cmd.Text);
      //if (Cmd.Items.IndexOf(Cmd.Text)=-1) and (Cmd.Text <> '') then Cmd.Items.Insert(0,Cmd.Text);
      Cmd.ItemIndex := 0; //first entry fix
      Cmd.ItemIndex := -1;

      if SayBox.Checked then
      begin
        Cmd.Text := '/say ';
        Cmd.SelStart := 5;
      end
      else if NickSayBox.Checked then
      begin
        Cmd.Text := '/say [' + Config.AdminName + '] ';
        Cmd.SelStart := Length('/say [' + Config.AdminName + '] ');
      end
      else if AdminBox.Checked then
      begin
        Cmd.Text := ' ';
        Cmd.SelStart := 2;
      end
      else
        Cmd.Text := '';
      RefreshClick(nil);
    except
    end;
  end;
end;

procedure TForm1.RefreshClick(Sender: TObject);
var
  i: integer;
begin
  if Form1.Visible then
    if Cmd.Enabled then
      Cmd.SetFocus
    else
      Panel1.SetFocus;
  i := ServerTab.TabIndex;
  if not ServerList[i].Client.Connected then
    exit;
  try
    ServerList[i].Client.WriteLn('REFRESHX');
  except
  end;
end;

procedure TForm1.RefreshTime();
var
  Perc, MasodPerc: Integer;
begin
  Perc := ServerList[ServerTab.TabIndex].RefreshMsg.CurrentTime div 3600;
  MasodPerc := (ServerList[ServerTab.TabIndex].RefreshMsg.CurrentTime - (Perc *
    3600)) div 60;
  TimeLeft.Caption := Format('%.2d:%.2d', [Perc, MasodPerc]);
end;

procedure TForm1.PlayerListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  pt: TPoint;
  item: TListItem;
begin
  if Button = mbRight then
  begin
    item := PlayerList.GetItemAt(X, Y);
    if item <> nil then
    begin
      pt.X := X;
      pt.Y := Y;
      pt := PlayerList.ClientToScreen(pt);
      PlayerList.PopupMenu.Popup(pt.x, pt.y);
    end;
  end;
end;

procedure TForm1.Kick1Click(Sender: TObject);
var
  i: integer;
  S: string;
  ch: char;
begin
  if PlayerList.Items.Count = 0 then
    exit;
  i := PlayerList.Itemindex;
  if (i < 0) or (i > (PlayerList.Items.Count - 1)) then
    exit;

  S := PlayerList.Items[i].Caption;

  Cmd.Text := '/kick ' + S;
  ch := #13;
  CmdKeyPress(nil, ch);
end;

procedure TForm1.Ban1Click(Sender: TObject);
var
  i: integer;
  S: string;
  ch: char;
begin
  if PlayerList.Items.Count = 0 then
    exit;
  i := PlayerList.Itemindex;
  if (i < 0) or (i > (PlayerList.Items.Count - 1)) then
    exit;

  S := PlayerList.Items[i].SubItems[ITEM_IP];

  Cmd.Text := '/tempban -1 ' + S;
  ch := #13;
  CmdKeyPress(nil, ch);
  Kick1Click(Sender);
end;

procedure TForm1.MoveToAlpha1Click(Sender: TObject);
var
  i: Char;
begin
  i := '1';
  MoveToTeam(nil, i);
end;

procedure TForm1.MoveToBravo1Click(Sender: TObject);
var
  i: Char;
begin
  i := '2';
  MoveToTeam(nil, i);
end;

procedure TForm1.MoveToCharlie1Click(Sender: TObject);
var
  i: Char;
begin
  i := '3';
  MoveToTeam(nil, i);
end;

procedure TForm1.MoveToDelta1Click(Sender: TObject);
var
  i: Char;
begin
  i := '4';
  MoveToTeam(nil, i);
end;

procedure TForm1.MoveToSpectator1Click(Sender: TObject);
var
  i: Char;
begin
  i := '5';
  MoveToTeam(nil, i);
end;

procedure TForm1.MoveToTeam(Sender: TObject; var Team: Char);
var
  i: integer;
  S: string;
  ch: char;
begin
  if PlayerList.Items.Count = 0 then
    exit;
  i := PlayerList.Itemindex;
  if (i < 0) or (i > (PlayerList.Items.Count - 1)) then
    exit;

  // S:= PlayerList.Items[i].SubItems[ITEM_NAME];
  S := PlayerList.Items[i].Caption;

  Cmd.Text := '/setteam' + Team + ' ' + S;
  ch := #13;
  CmdKeyPress(nil, ch);
end;

procedure TForm1.RefreshTimerTimer(Sender: TObject);
var
  i: integer;
begin
  // if (Config.Auto) then RefreshClick(nil);
  if not Config.Auto then
    exit;

  for i := 0 to ServerTab.Tabs.Count - 1 do
  begin
    // ServerList[i].Memo.Lines.Add('paty paty refresh');
    try
      if ServerList[i].Client.Connected then
      begin
        ServerList[i].Client.WriteLn('REFRESHX');
      end;
      //   if ServerList[i].Client.Connected then ServerList[i].Client.WriteLn('REFRESH');
    except
    end;
  end;

end;

procedure TForm1.OnMessageHandler;
begin
  // for always on top feature
  if Msg.message = WM_SYSCOMMAND then
  begin
    case Msg.wParam of
      // Which item selected?
      // Welches Menitem wurde ausgew�hlt?
      SC_AlwaysOnTopMenuItem:
        begin
          if isAlwaysOnTop then
          begin
           SetWindowPos(Form1.Handle,
              HWND_NOTOPMOST,
              0, 0, 0, 0,
              SWP_NOMOVE or SWP_NOSIZE or SWP_SHOWWINDOW);
           CheckMenuItem(GetSystemMenu(Application.Handle, False),SC_AlwaysOnTopMenuItem ,MF_UNCHECKED);
           CheckMenuItem(GetSystemMenu(Handle, False),SC_AlwaysOnTopMenuItem,MF_UNCHECKED);
           end
           else
           begin
           SetWindowPos(Form1.Handle,
              HWND_TOPMOST,
              0, 0, 0, 0,
              SWP_NOMOVE or SWP_NOSIZE or SWP_SHOWWINDOW);
           CheckMenuItem(GetSystemMenu(Application.Handle, False),SC_AlwaysOnTopMenuItem,MF_CHECKED);
           CheckMenuItem(GetSystemMenu(Handle, False),SC_AlwaysOnTopMenuItem,MF_CHECKED);
           end;
          isAlwaysOnTop:=not isAlwaysOnTop;
          Handled := True;
        end;
    end;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i: integer;
  //  isbeta: string;
  f: file;
  changes: TStringList;
  delay: byte;
  path: string;
  hSysMenu: THandle;
begin
  // add always on top menu
  isAlwaysOnTop := false;

  hSysMenu := GetSystemMenu(Application.Handle, False);
  AppendMenu(hSysMenu, MF_SEPARATOR, 0, #0);
  AppendMenu(hSysMenu, MF_STRING or MF_UNCHECKED , SC_AlwaysOnTopMenuItem, '&Always on Top');

  hSysMenu := GetSystemMenu(Handle, False);

  AppendMenu(hSysMenu, MF_SEPARATOR, 0, #0);
  AppendMenu(hSysMenu, MF_STRING or MF_UNCHECKED , SC_AlwaysOnTopMenuItem, '&Always on Top');

  Application.OnMessage := OnMessageHandler;  // to handle the menu click event

  Config.AdminName := 'SetYourNameInConfig';
  Config.SoundFileName := '';
  Config.ColorMain := clBlack;
  Config.ColorText := clLime;
  Config.ColorChat := clAqua;
  Config.ColorAdmin := clYellow;
  Config.ColorPm := clYellow;
  Config.ColorTeam := clSkyBlue;
  Config.ColorMuted := clSilver;
  Config.ColorAdmChat := clSilver;
  Config.ColorClientList := clOlive;

  Config.CustomColors := TStringList.Create;

  // Config.CustomColors.Add('* scores for Alpha Team=clRed');
  // Config.CustomColors.Add('* scores for Bravo Team=clBlue');

  // ShowMessage(Config.CustomColors.Names[1]+ ' (weee)  '+Config.CustomColors.ValueFromIndex[1]);

  // FUpdateActive:=false;
  // isbeta:= '';
  //isbeta:= ' BETA';
  mutathatod := true;
  TabClicked := false;
  // if not ((strtoint(VERSIONBUILD) mod 2) = 0) then isbeta:= ' BETA';
  Form1.Caption := Form1.Caption + ' v' + VERSION + '.' + VERSIONBUILD + ' ' +
    VERSIONSTATUS; //VERSION;
  // if not ((strtoint(VERSIONBUILD) mod 2) = 0) then isbeta:= 'b';
  // Form1.Caption:= Form1.Caption + ' v' + VERSION + isbeta + ' (Build ' + VERSIONBUILD + ')';//VERSION;

  // Settings1:= Settings1.Create(Application);

  for I := 0 to ComponentCount - 1 do
    if (Components[I] is TWinControl) and not (Components[I] is TRichEdit) and
      not (Components[I] is TComboBox) and not
      (Components[I] is TListBox) then
      TWinControl(Components[I]).DoubleBuffered := True;
  //}

  // Config.AutoMessageList:= TStringList.Create;
  Config.EventFile := TStringList.Create;
  Config.Events := TStringList.Create;
  Config.HotkeyDescription := TStringList.Create;
  Config.TeamKillers := TStringList.Create;

  Config.Events.Add('OnLoad');
  Config.EventFile.Add('');
  Config.Events.Add('OnExit');
  Config.EventFile.Add('');
  { Config.Events.Add('OnConnect');
   Config.Events.Add('OnDisconnect');
   Config.Events.Add('OnJoinRequest');
   Config.Events.Add('OnPlayerJoin');
   Config.Events.Add('OnPlayerLeave');
   Config.Events.Add('OnPlayerSpeak');
   Config.Events.Add('OnAdminConnect');
   Config.Events.Add('OnAdminDisconnect');
   Config.Events.Add('OnTimeLeft');
   Config.Events.Add('OnData');
   Config.Events.Add('OnRefresh');
  }
  Config.Events.Add('OnIRCMessage');
  Config.EventFile.Add('');
  Config.Events.Add('OnIRCJoin');
  Config.EventFile.Add('');
  Config.Events.Add('OnIRCPart');
  Config.EventFile.Add('');
  Config.Events.Add('OnIRCConnect');
  Config.EventFile.Add('');
  Config.Events.Add('OnIRCDisconnect');
  Config.EventFile.Add('');

  // actual text for hotkeys
  Config.HotkeyDescription.add('Ban selected player (in player list)');
  Config.HotkeyDescription.add('Connect to current server');
  Config.HotkeyDescription.add('Disconnect from current server');
  Config.HotkeyDescription.add('Toggle Chat mode');
  Config.HotkeyDescription.add('Scroll console to bottom');
  Config.HotkeyDescription.add('Search');
  Config.HotkeyDescription.add('Scroll console to top');
  Config.HotkeyDescription.add('Expand server info-bar');
  Config.HotkeyDescription.add('Kick selected player (in player list)');
  Config.HotkeyDescription.add('Toggle Nick Chat mode');
  Config.HotkeyDescription.add('Set server password');
  Config.HotkeyDescription.add('Scroll console down');
  Config.HotkeyDescription.add('Scroll console up');
  Config.HotkeyDescription.add('Perform script recompile (/recompile)');
  Config.HotkeyDescription.add('Send server message');
  Config.HotkeyDescription.add('Toggle Admin chat mode');
  Config.HotkeyDescription.add('Send PM to selected player (in player list)');
  Config.HotkeyDescription.add('Send Clientlist command');

  LoadConfig(ExtractFilePath(Application.ExeName) + 'arsse.ini');
  LoadCommandBox(ExtractFilePath(Application.ExeName) + 'CommandBox.txt');

  TrayIcon.cbSize := SizeOf(TrayIcon);
  TrayIcon.Wnd := Self.Handle;

  TrayIcon.uFlags := NIF_ICON or NIF_TIP or NIF_MESSAGE;

  TrayIcon.hIcon := Application.Icon.Handle;
  TrayIcon.szTip := 'Advanced Remote Soldat Server Enchanter';
  TrayIcon.uID := MYTRAYICONID;
  TrayIcon.uCallbackMessage := UM_NOTIFYICON;

  // ClickedTab:= ServerTab.TabIndex;
  Application.OnMinimize := MinimizeToTray;
  Form1.OnResize := FormResize;

  if Config.EventOn[0] then
    EventOccure('', '', Config.EventFile[0], ServerTab.Tabindex);

  ///////INIT//////
  AdminBubi.OnClick := Form1.AdminBubiClick; // manual assign bc not working else
  AdminBubi.prompt.clear(); // remove ad and spam stuff...
  AdminBubi.Prompt.Add('');
  ///////INIT//////

  path := ExtractFilePath(Application.ExeName);

  // Check for old versions after update
  if FileExists(Application.ExeName + '_old') then
  begin
    delay:=0;
    while IsFileInUse(Application.ExeName+'_old') and (delay<37) do
    begin
        sleep(100);
        delay:=delay+1;
    end;
    //  sleep(1000);

    if FileExists(ExtractFilePath(Application.ExeName) + CHANGESFILE) then
    begin
      changes := TStringList.Create;
      changes.LoadFromFile(ExtractFilePath(Application.ExeName) + CHANGESFILE);

      //ShowMessage(changes.Text);
      try
        //Config.mintotray:=false;
        UpdatePopup1 := TUpdatePopup1.Create(nil);
        UpdatePopup1.Memo1.Text := changes.Text;
        UpdatePopup1.Show;
      except
      end;
      //Config.mintotray:=true;
      //showmessage('ging');
    end;
    AssignFile(f, Application.ExeName + '_old');
    Erase(f);
  end;

  // compatibility fix
  if FileExists(path + 'ip.adb') then
  begin
    RenameFile(path + 'ip.adb', path + 'data\ip.adb_new');
  end;

  if FileExists(path + 'data\ip.adb_new') then
  begin
    if FileExists(path + 'data\ip.adb') then
    begin
      try
        AssignFile(f, path + 'data\ip.adb');
        Erase(f);
      finally
      end;
    end;
    if not FileExists(path + 'data\ip.adb') then
    begin
      RenameFile(path + 'data\ip.adb_new', path + 'data\ip.adb');
    end;
  end;

  if Config.autoupdate then
  begin
    case Config.updatefreq of
      0: if CompareDate(Date, Config.updatetime + 30) >= 0 then
          ManualUpdateClick(Form1);
      1: if CompareDate(Date, Config.updatetime + 7) >= 0 then
          ManualUpdateClick(Form1);
      2: if CompareDate(Date, Config.updatetime + 1) >= 0 then
          ManualUpdateClick(Form1);
    end;
  end;

  // ManualUpdateClick(nil);

  ClickedTab := ServerTab.TabIndex;
  SortDirection := -1;
  ColumnToSort := COLUMN_KILLS;
  PlayerList.AlphaSort;

  //for nametab completion
  tabpresscount := 0;
  completednick := '';
  nickcompletionlist := TStringList.Create;

  DBFile := TFlagDB.Create(path + 'data\ip.adb');

  // load all flag images 
  for i := 0 to 253 do
  begin
    CountryFlags[i] := TGIFImage.Create();

    // change missing files to unknown flag
    if (i = 1) or (i = 12) or (i = 75) or ((i > 243) and (not i = 247)
      and (not i = 253)) then
    begin
      if Fileexists(path + 'flags\--.gif') then
        CountryFlags[i].LoadFromFile(path + 'flags\--.gif');
    end
    else if Fileexists(path + 'flags\' + CountryCodes[i] + '.gif') then
      CountryFlags[i].LoadFromFile(path + 'flags\' + CountryCodes[i] + '.gif');
  end;

  for i := COLUMN_ID to COLUMN_NUM do
  begin
    columnsWidth[i] := PlayerList.Column[i].Width;
    columnsMinWidth[i] := PlayerList.Column[i].minWidth;
    columnsVisibility[i] :=  true;
  end;

  FormResize(Form1);
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: integer;
  connected: boolean;
begin
  if Self.Visible then
  begin
    if Cmd.focused then
    begin
      PlayerList.SetFocus;
    end
    else if Host.focused then
    begin
      PlayerList.SetFocus;
    end;
  end;

  if Assigned(UpdtThread) then
  begin
    if MessageDlg('Update in process! Exit anyway?', mtWarning, [mbYes, mbNo], 0)
      <> mrYes then
    begin
      UpdtThread.Terminate; //dunno why you do that
      Action := caNone;
    end
    else
    begin
      UpdtThread.FreeOnTerminate := true;
      // maybe we need to check this stuff here
      UpdtThread.Terminate; // user could quit when ARSSE.exe is written
      //    UpdtThread.Free;                    // didnt do much research how you did the update stuff
      UpdtThread := nil;
    end;
  end;

  if Config.EventOn[1] then
    EventOccure('', '', Config.EventFile[1], ServerTab.Tabindex);

  connected := false;

  for i := 0 to ServerTab.Tabs.Count - 1 do
    if ServerList[i].Client.Connected then
    begin
      if MessageDlg('You are still connected. Exit anyway?', mtConfirmation,
        [mbYes, mbNo], 0) <> mrYes then
        Action := caNone
      else
        connected := true;
      break;
    end;

  if connected then
    for i := 0 to ServerTab.Tabs.Count - 1 do
      if ServerList[i].Client.Connected then
      begin
        ServerList[i].Client.Disconnect;
        WriteToLog('Session Close: ' +
          FormatDateTime('ddd mmm dd hh:mm:Ss yyyy', now), i);
        WriteToLog('', i);
      end;

  if IRC.Connected then
    IRCConnectClick(nil);

  if Action <> caNone then
  begin
    SaveConfig(ExtractFilePath(Application.ExeName) + 'arsse.ini');
    SaveCommandBox(ExtractFilePath(Application.ExeName) + 'CommandBox.txt');
    Shell_notifyIcon(NIM_DELETE, @TrayIcon);
    DBFile.Destroy;
    for i := 0 to 253 do
      if CountryFlags[i] <> nil then
        CountryFlags[i].Free;
  end
  else
  begin
    if PlayerList.Focused then
      if Cmd.Enabled then
        Cmd.Setfocus
      else
        Host.SetFocus;
  end;

end;

procedure TForm1.Kickall(const command: string; index: integer);
var
  i: integer;
  id: string;
begin
  // goes through all players and runs a command for each
  for i := MAX_PLAYERS downto 1 do
    // check for available players
    if ServerList[index].RefreshMsg.Team[i] < 6 then
    begin
      // get playerid
      id := inttostr(ServerList[index].RefreshMsg.Number[i]);
      try
        // run command for player
        ServerList[index].Client.WriteLn(command + ' ' + id);
      except
      end;

    end;
end;

procedure TForm1.ConnectIt(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    ConnectClick(nil);
    Key := #0;
  end;
end;

procedure TForm1.DoHotkeyCommand(Commands: TStringList);
var
  // ch : char;
  // Odialog, Odialog2, Odialog3: boolean;
  // Command: string;
  // vegeredmeny,
  Command, seged, seged2, cim, kerdes, ujstring: string;
  i, a, b: integer;
  igen: boolean;
  // Registry: TRegistry;
begin
  for i := 0 to Commands.Count - 1 do
  begin
    Command := Commands.Strings[i];
    MyDialogBox.ParamValue.Text := '';

    if Matches('$CONFIRM*(*)', Command) then
    begin
      seged := Command;
      a := Pos('(', seged);
      b := Pos(''')', seged) - a + 1;
      seged := Copy(seged, a + 1, b - 1);
      seged := StringReplace(seged, #39, '', [rfReplaceAll]);
      seged := Trim(Seged);

      if MessageDlg(seged, mtConfirmation, [mbOk, mbCancel], 0) = mrCancel then
        exit;
    end;

    if Matches('$JOINSOLDAT', Command) then
    begin
      ShellExecute(Form1.Handle, nil, PChar('soldat://' +
        ServerList[ServerTab.Tabindex].Client.Host + ':' +
        inttostr(ServerList[ServerTab.Tabindex].Client.Port) + '///'), nil, nil,
        SW_SHOW);
    end;

    if Matches('CLEAR', Command) then
    begin
      MemoAppend(ServerTab.TabIndex, ServerList[ServerTab.TabIndex].Memo.Font.Color, ''); //default textcolor fix
      ServerList[ServerTab.TabIndex].Memo.Clear;
    end;

    if Matches('OPENSERVERLOG', Command) then
    begin
      ShellExecute(0, 'open', PChar(ExtractFilePath(Application.ExeName) +
        'logs\' + ServerList[ServerTab.TabIndex].ServerName + '.log\' +
        FormatDateTime('yyyy_mm_dd', Date) + '.txt'), PChar(0), PChar(0),
        SW_SHOWNORMAL);
    end;

    while Matches('*$TEAMSELECT*', Command) do
    begin
      BotHelp.Enabled := false;
      MyDialogBox.Caption := 'Team selection';
      MyDialogBox.ParamLabel.Caption := 'Select Team:';
      igen := true;
      ujstring := '';
      case ServerList[ServerTab.TabIndex].RefreshMsg.GameStyle of
        2: SetDialogButtons('Alpha', 'Bravo', 'Charlie', 'Delta', false);
        3, 5, 6: SetDialogButtons('Alpha', 'Bravo', 'false', 'false', false);
      else
        igen := false;
      end;
      if igen then
        case MyDialogBox.ShowModal of
          mrYes: ujstring := '1';
          mrOK: ujstring := '2';
          mrCancel: ujstring := '3';
          mrNo: ujstring := '4';
        else
          ujstring := '';
        end;
      Command := StringReplace(Command, '$TEAMSELECT', ujstring, []);
      ujstring := '';
    end;

    while Matches('*$INPUT(*):$LOAD*', Command) do
    begin
      ujstring := '';
      seged := Command;
      a := Pos('$INPUT', seged);
      b := Pos(''')', seged) - a + 2;
      seged := Copy(seged, a, b);
      cim := Copy(seged, Pos('(', seged) + 1, Pos(',', seged) - Pos('(',
        seged));
      cim := Copy(cim, 0, LastDelimiter(',', cim) - 1);
      cim := StringReplace(cim, #39, '', [rfReplaceAll]);
      cim := Trim(cim);
      kerdes := Copy(seged, Pos(',', seged) + 1, Pos(''')', seged) - Pos(',',
        seged) - 1);

      kerdes := StringReplace(kerdes, #39, '', [rfReplaceAll]);
      kerdes := Trim(kerdes);
      seged2 := Copy(Command, Pos(seged, Command) + Length(seged),
        Length(Command));

      BotHelp.Enabled := true;
      MyDialogBox.ParamLabel.Caption := kerdes;
      MyDialogBox.Caption := cim;
      SetDialogButtons('false', 'Ok', 'Cancel', 'false', true);

      if Matches(':$LOADBOTS*', seged2) then
      begin
        Command := StringReplace(Command, ':$LOADBOTS', '', []);
        SetDialogButtons('false', 'Ok', 'Cancel', 'false', true);
        LoadBots(1);
      end;

      if Matches(':$LOADBANS*', seged2) then
      begin
        Command := StringReplace(Command, ':$LOADBANS', '', []);
        SetDialogButtons('false', 'Ok', 'Cancel', 'false', true);
        LoadBots(2);
      end;

      if Matches(':$LOADMAPS*', seged2) then
      begin
        Command := StringReplace(Command, ':$LOADMAPS', '', []);
        if (ServerList[ServerTab.TabIndex].RefreshMsg.GameStyle < 3) or
          (ServerList[ServerTab.TabIndex].RefreshMsg.GameStyle =
          4) then
          LoadMaps(1);
        if (ServerList[ServerTab.TabIndex].RefreshMsg.GameStyle = 3) then
          LoadMaps(2);
        if (ServerList[ServerTab.TabIndex].RefreshMsg.GameStyle = 5) then
          LoadMaps(3);
        if (ServerList[ServerTab.TabIndex].RefreshMsg.GameStyle = 6) then
          LoadMaps(4);
      end;

      case MyDialogBox.ShowModal of
        mrOK: ujstring := MyDialogBox.ParamValue.Text;
      else
        begin
          ujstring := '';
          exit;
        end;
      end;

      Command := StringReplace(Command, seged, ujstring, []);
    end;

    while Matches('*$INPUT(*)*', Command) do
    begin
      seged := Command;
      a := Pos('$INPUT', seged);
      b := Pos(''')', seged) - a + 2; //Length(seged)+1-a;
      //   seged2:= Copy(seged,0,a);
      seged := Copy(seged, a, b);
      cim := Copy(seged, Pos('(', seged) + 1, Pos(',', seged) - Pos('(',
        seged));
      cim := Copy(cim, 0, LastDelimiter(',', cim) - 1);
      cim := StringReplace(cim, #39, '', [rfReplaceAll]);
      cim := Trim(cim);
      kerdes := Copy(seged, Pos(',', seged) + 1, Pos(''')', seged) - Pos(',',
        seged) - 1);
      //   ServerList[ServerTab.TabIndex].Memo.Lines.Add(kerdes+ ' :: ' + seged + ' :: ' + inttostr(Pos(#39')',seged)));
      kerdes := StringReplace(kerdes, #39, '', [rfReplaceAll]);
      kerdes := Trim(kerdes);
      igen := InputQuery(cim, kerdes, ujstring);
      Command := StringReplace(Command, seged, ujstring, []);
      if not igen then
        exit;
    end;

    while Matches('*$TOGGLE(*)*', Command) do
    begin
      seged := Command;
      a := Pos('$TOGGLE', seged);
      b := Pos(''')', seged) - a + 2;
      seged := Copy(seged, a, b);
      cim := Copy(seged, Pos('(', seged) + 1, Pos(',', seged) - Pos('(',
        seged));
      cim := Copy(cim, 0, LastDelimiter(',', cim) - 1);
      cim := StringReplace(cim, #39, '', [rfReplaceAll]);
      cim := Trim(cim);
      kerdes := Copy(seged, Pos(',', seged) + 1, Pos(''')', seged) - Pos(',',
        seged) - 1);
      kerdes := StringReplace(kerdes, #39, '', [rfReplaceAll]);
      kerdes := Trim(kerdes);
      //   igen:= InputQuery(cim,kerdes,ujstring);

      BotHelp.Enabled := false;
      MyDialogBox.Caption := cim;
      MyDialogBox.ParamLabel.Caption := kerdes;
      ujstring := '';
      igen := true;
      SetDialogButtons('On', 'Off', 'false', 'Cancel', false);
      case MyDialogBox.ShowModal of
        mrYes: ujstring := '1';
        mrOK: ujstring := '0';
      else
        igen := false;
      end;

      Command := StringReplace(Command, seged, ujstring, []);
      if not igen then
        exit;
    end;

    if Matches('/*', Command) or (Command = 'SHUTDOWN') then
    begin
      if Matches('/amsg *', Command) then
        ARSSECommands(Command, ServerTab.TabIndex)
      else
        ServerList[ServerTab.TabIndex].Client.WriteLn(Command);
    end;

  end; //for v�ge
end;

procedure TForm1.PerformActionClick(Sender: TObject);
begin
  if ActionList.ItemIndex = -1 then
    exit;

  DoHotkeyCommand(Config.CommandBox[ActionList.ItemIndex].Commands);

  RefreshClick(nil);

  // if Cmd.Enabled then
    // Cmd.SetFocus
  // else
    // Panel1.SetFocus;
  SetFocusToCmd(Sender);
end;

procedure TForm1.ParameterChange(Sender: TObject);
begin
  // if strtoint(Parameter.Text) > 5 then Parameter.Text:= '5';
end;

procedure TForm1.ParameterKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    PerformActionClick(nil);
end;

procedure TForm1.Remove1Click(Sender: TObject);
var
  i: integer;
  S: string;
  ch: char;
begin
  if PlayerList.Items.Count = 0 then
    exit;
  i := PlayerList.Itemindex;
  if (i < 0) or (i > (PlayerList.Items.Count - 1)) then
    exit;

  S := PlayerList.Items[i].SubItems[ITEM_IP];

  Cmd.Text := '/unadm ' + S;
  ch := #13;
  CmdKeyPress(nil, ch);
end;

procedure TForm1.HostSelect(Sender: TObject);
begin
  ServerTab.Tabs[ServerTab.TabIndex] := Fav_Serv.Name[Host.ItemIndex];
  ServerList[ServerTab.TabIndex].ServerName := Fav_Serv.Name[Host.ItemIndex];
  Port.Text := Fav_Serv.Port[Host.ItemIndex];
  Pass.Text := Fav_Serv.Pass[Host.ItemIndex];

  ServerList[ServerTab.TabIndex].Client.Host := Host.Text;
  ServerList[ServerTab.TabIndex].Client.Port := strtoint(Port.Text);
  ServerList[ServerTab.TabIndex].Pass := Pass.Text;
end;

procedure TForm1.AddFavServClick(Sender: TObject);
var
  // F: textfile;
  // newfavsrv, servers, seged, favserv : string;
  // realnewserv: boolean;
  // hostP, portP, passP,
  i, j: integer;
  conf: TStringlist;
  sections: TStringlist;
  ini: Tinifile;
  // fav_ini: Tinifile;
begin

  if (Host.Text = '') or (Port.Text = '') then
  begin
    MessageDlg('Error: not enough server data specified', mtError, [mbOk], 0);
    exit;
  end;

  // realnewserv:= true;
  conf := Tstringlist.create;
  sections := Tstringlist.create;
  ini := Tinifile.Create(ExtractFilePath(Application.ExeName) +
    'fav_servers.ini');

  ini.ReadSections(sections);

  {
  if sections.Count > 0 then j:= sections.Count
   else
   begin
    j:= 0;
  //  sections[0]:= '0';
   end;
  }

  if sections.Count > 0 then
    for i := 0 to sections.Count - 1 do
    begin
      ini.ReadSectionValues(sections[i], conf);
      if (conf.Values['Host'] = Host.Text) and (conf.Values['Port'] = Port.Text)
        then
      begin
        //   realnewserv:= false;
        MessageDlg('Error: already in favorites', mtError, [mbOk], 0);
        exit;
      end;
    end;

  j := sections.Count;

  if j > 0 then
    j := strtoint(sections[j - 1]) + 1
  else
    j := 1;

  //  ini.WriteString(inttostr(j), 'Name', ServerTab.Tabs[ServerTab.Tabindex]);
  ini.WriteString(inttostr(j), 'Name',
    ServerList[ServerTab.Tabindex].ServerName);
  ini.WriteString(inttostr(j), 'Host', Host.Text);
  ini.WriteString(inttostr(j), 'Port', Port.Text);
  ini.WriteString(inttostr(j), 'Pass', idEncoderUUE1.Encode(Pass.Text));

  //  Fav_Serv.Name.Add(ServerTab.Tabs[ServerTab.Tabindex]);
  Fav_Serv.Name.Add(ServerList[ServerTab.Tabindex].ServerName);
  Fav_Serv.Host.Add(Host.Text);
  Fav_Serv.Port.Add(Port.Text);
  Fav_Serv.Pass.Add(Pass.Text);

  Host.Items.Add(Host.Text);

  MessageDlg('Server added to favorite servers.', mtInformation, [mbOk], 0);
  //}

  ini.free;
  conf.free;
  sections.Free;

  {
   realnewserv:= true;
   newfavsrv:= Host.Text + ':' + Port.Text + '|';
   if Config.savepass then newfavsrv:= newfavsrv + idEncoderUUE1.Encode(Pass.Text);

   AssignFile(f, ExtractFilePath(Application.ExeName) +  'admfavsrvs.txt');
   if not fileexists(ExtractFilePath(Application.ExeName) + 'admfavsrvs.txt') then Rewrite(F);
    Try
    Reset(F);
    except
    end;

   while not Eof(f) do
    begin
  //  realnewserv:= false;
    ReadLn(F,servers);
    if StrComp(PChar(servers),PChar(newfavsrv)) = 0 then realnewserv:=false
    else realnewserv:= true;

      seged:='';
      hostP:= Pos(':',servers);
      portP:= Pos('|',servers);
      passP:= Length(servers);
      for i:= 1 to hostP-1 do seged:= seged + servers[i];
      favserv:= seged + ':';
      seged:= '';
      for i:= hostP+1 to portP-1 do seged:= seged + servers[i];
      favserv := favserv + seged + '|';
      seged:= '';
      if Pass.Text <> '' then
      begin
       for i:= portP+1 to passP do seged:= seged + servers[i];
       favserv:= favserv + seged;
       if not Config.savepass then seged:= newfavsrv + Pass.Text;
      end; //if password not null

    if StrComp(PChar(favserv),PChar(seged)) = 0 then realnewserv:=false;

    if not realnewserv then
    begin
     MessageDlg('Error: already in favorites', mtError,[mbOk], 0);
     break;
    end;//if not real new server

   end;//while not end of file

   if (AnsiReplaceStr(newfavsrv,' ','') = ':|') or (AnsiReplaceStr(Host.Text,' ','') = '') then
   begin
    MessageDlg('Error: not enough server data specified', mtError,[mbOk], 0);
    exit;
   end;// if no host specified

   if realnewserv then
   begin

    inc(Fav_Serv.ItemNum);
    Append(f);
    Writeln(f, newfavsrv);
    Flush(f);
    MessageDlg('Server added to favorite servers.', mtInformation,[mbOk], 0);
    Fav_Serv.Host[Fav_Serv.ItemNum]:=Host.Text;
    Fav_Serv.Port[Fav_Serv.ItemNum]:=Port.Text;
    if Config.savepass then Fav_Serv.Pass[Fav_Serv.ItemNum]:=Pass.Text;
    Host.Items.Add(Fav_Serv.Host[Fav_Serv.ItemNum]);
   end;
   CloseFile(f);
  }
end;

procedure TForm1.OpenParamInput(const Command, Msg: string);
var
  ch: char;
begin
  ch := #13;
  Cmd.Text := Command;
  BotHelp.Enabled := false;
  MyDialogBox.ParamLabel.Caption := Msg;
  MyDialogBox.ParamValue.Text := '';
  // DialogButtonsS1();
  SetDialogButtons('false', 'Ok', 'Cancel', 'false', true);
  if MyDialogBox.ShowModal = mrOK then
    Cmd.Text := Cmd.Text + MyDialogBox.ParamValue.Text
  else
  begin
    ch := #0;
    Cmd.Text := '';
  end;
  CmdKeyPress(nil, ch);
end;

procedure TForm1.HotKeyPress(Sender: TObject; var Key: Char);
begin
  // HideCaret(Memo.Handle);
  //if not Client.Connected then exit;

  //MessageDlg(Key + ' has been pressed', mtInformation, [mbOK], 0);

  {if HotKey = #0 then}
  // case Key of
  //  'b','B' : if (PlayerList.Selected <> nil) and (MessageDlg('Ban '+PlayerList.Selected.SubItems[0] + '?',mtConfirmation, [mbYes, mbNo], 0) = mrYes) then begin ServerList[ServerTab.TabIndex].Client.WriteLn('/ban '+PlayerList.Selected.SubItems[0]); end;
  //  'k','K' : if (PlayerList.Selected <> nil) and (MessageDlg('Kick '+PlayerList.Selected.SubItems[0] + '?',mtConfirmation, [mbYes, mbNo], 0) = mrYes) then begin ServerList[ServerTab.TabIndex].Client.WriteLn('/kick '+PlayerList.Selected.SubItems[0]); end;

  //  's','S' : if ServerList[ServerTab.TabIndex].Client.Connected then ShutdownClick(nil);
  //  'c','C' : if not ServerList[ServerTab.TabIndex].Client.Connected then ConnectClick(nil);
  //  'd','D' : if ServerList[ServerTab.TabIndex].Client.Connected  and (MessageDlg('Disconnect from '+  ServerList[ServerTab.TabIndex].ServerName +'?',mtConfirmation, [mbYes, mbNo], 0) = mrYes) then ConnectClick(nil);
  //  'p','P' : if ServerList[ServerTab.TabIndex].Client.Connected then  begin if Cmd.Text='' then Cmd.Text:= '/password '; Cmd.SetFocus; Cmd.SelLength:=0; Cmd.SelStart:=Length(Cmd.Text); end;
          // OpenParamInput('/password ', 'Enter new server password:');

  //  't','T' : if ServerList[ServerTab.TabIndex].Client.Connected then  begin if Cmd.Text='' then Cmd.Text:= '/say '; Cmd.SetFocus; Cmd.SelLength:=0; Cmd.SelStart:=Length(Cmd.Text); end;
          //OpenParamInput('/say ', 'Enter message:');

  //  '/': if ServerList[ServerTab.TabIndex].Client.Connected then begin if Cmd.Text='' then Cmd.Text:= '/'; Cmd.SetFocus; Cmd.SelLength:=0; Cmd.SelStart:=Length(Cmd.Text); end;

  //  'z': if PlayerList.Selected <> nil  then begin Cmd.Text:= '/pm '+PlayerList.Selected.Caption+' '; Cmd.SetFocus; Cmd.SelLength:=0; Cmd.SelStart:=Length(Cmd.Text); end;
          // OpenParamInput('/pm '+PlayerList.Selected.Caption+' ', 'Private Message to '+PlayerList.Selected.SubItems[0] + ':');

  //  'i': if infoON then MoreInfoMouseLeave(nil)
  //        else MoreInfoMouseEnter(nil);

  //  #32 : PlayerList.SetFocus;
  // end;
  if Key = #14 then
    SearchForm1.NextClick(TObject(SearchForm1));
  if ((Key = #18) or (Key = #5)) and Ctrl and not Shift then
  begin
    keybd_event(ord('L'), 0, 0, 0);
    keybd_event(ord('L'), 0, KEYEVENTF_KEYUP, 0);
  end;
  Key := #0;
  {
  else
  begin
   ch:= #13;
   case HotKey of
    'b': Cmd.Text:= '/ban ' + Key;
    'k': Cmd.Text:= '/kick ' + Key;
  //  's': begin ShutdownClick(nil); ch:=#0; end;
   end;
  // HotKey:= Key;
   Hotkey:= #0;
   CmdKeyPress(nil,ch);
  end;
  //}

end;

procedure TForm1.TimerLeftTimer(Sender: TObject);
begin
  if ServerList[ServerTab.TabIndex].RefreshMsg.CurrentTime >= 60 then
    dec(ServerList[ServerTab.TabIndex].RefreshMsg.CurrentTime, 60);
  RefreshTime();
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
  close;
end;

procedure TForm1.Restore1Click(Sender: TObject);
begin
  RestoreMainForm;
end;

procedure TForm1.MinimizeToTray(Sender: TObject);
begin
  if Config.mintotray then
  begin
    Shell_notifyIcon(NIM_ADD, @TrayIcon);
    Form1.Visible := false;
  end;
end;

procedure TForm1.RestoreMainForm;
begin
  Form1.Visible := true;
  Application.Restore;
  Application.BringToFront;
  SetFocus; //I.e. Form1.
  Shell_notifyIcon(NIM_DELETE, @TrayIcon);
end;

procedure TForm1.ShowThePopup;
var
  CurPos: TPoint;
begin
  SetForeGroundWindow(Application.Handle);
  GetCursorPos(CurPos);
  Application.ProcessMessages;
  PopupMenu1.Popup(CurPos.x, CurPos.y);
  PostMessage(Self.Handle, WM_NULL, 0, 0);
end;

procedure TForm1.PlayerListColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  if Column.Index = ColumnToSort then
    SortDirection := SortDirection * -1;
  ColumnToSort := Column.Index;
  (Sender as TCustomListView).AlphaSort;
end;

procedure TForm1.PlayerListCompare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
var
  ix: Integer;
  //  ertek1, ertek2: string;
begin
  {
    ertek1:= Item1.SubItems[ColumnToSort - 1];
    ertek2:= Item2.SubItems[ColumnToSort - 1];
    if (Item1.SubItems[5] = 'Spectator') then ertek1:= '65536';
    if (Item2.SubItems[5] = 'Spectator') then ertek2:= '65536';
  }
  if ColumnToSort = COLUMN_ID then
    if strtoint(Item1.Caption) < strtoint(Item2.Caption) then
      Compare := SortDirection * -1
    else if strtoint(Item1.Caption) > strtoint(Item2.Caption) then
      Compare := SortDirection * 1
    else
      Compare := 0
  else //if (Item1.SubItems[ITEM_TEAM] <> 'Spectator') and (Item2.SubItems[ITEM_TEAM] <>
    {'Spectator') then}
  begin
    ix := ColumnToSort - 1;
    if (ColumnToSort >= COLUMN_KILLS) and (ColumnToSort <= COLUMN_PING) then
      if (strtofloat(Item1.SubItems[ix]) < strtofloat(Item2.SubItems[ix])) then
        Compare := SortDirection * -1
      else if (strtofloat(Item1.SubItems[ix]) > strtofloat(Item2.SubItems[ix]))
        then
        Compare := SortDirection * 1
      else
      begin
        if ColumnToSort <> COLUMN_PING then
          inc(ix);
        if strtofloat(Item1.SubItems[ix]) < strtofloat(Item2.SubItems[ix]) then
          Compare := -1
        else if strtofloat(Item1.SubItems[ix]) > strtofloat(Item2.SubItems[ix])
          then
          Compare := 1
        else
          Compare := 0;
      end
    else
      Compare := CompareText(Item1.SubItems[ix], Item2.SubItems[ix]) *
        SortDirection;
  end;

  {if (Item1.SubItems[ITEM_TEAM] = 'Spectator') and (Item2.SubItems[ITEM_TEAM] = 'Spectator')
    then
    Compare := 0
  else if (Item1.SubItems[ITEM_TEAM]) = 'Spectator' then
    Compare := 1
  else if (Item2.SubItems[ITEM_TEAM]) = 'Spectator' then
    Compare := -1;}

end;

procedure TForm1.SettingsClick(Sender: TObject);
var
  i, proba, proba2: integer;
  item: TListItem;
begin

  proba := 12;
  proba2 := 11;

  // Settings1.Caption:= 'Configuration of '+ServerTab.Tabs[ServerTab.TabIndex];
  Settings1.Caption := 'Configuration of ' +
    ServerList[ServerTab.TabIndex].ServerName;

  with Settings1 do
  begin
    IRCServer.Text := Config.IRC.Server;
    IRCPort.Text := inttostr(Config.IRC.Port);
    IRCNick.Text := Config.IRC.Nick;
    IRCAltNick.Text := Config.IRC.AltNick;
    IRCUsername.Text := Config.IRC.Username;
    IRCChannel.Text := Config.IRC.Channel;
    IRCKey.Text := Config.IRC.ChanKey;
    prefix.Text := Config.IRC.Prefix;
    QNetAuth.Checked := Config.IRC.auth;
    QNetUser.Text := Config.IRC.ANick;
    QNetPass.Text := Config.IRC.APass;
    QNetBot.Text := Config.IRC.ABot;
    QNetCmd.Text := Config.IRC.ACmd;
  end;

  ////////////// GLOBAL SETTINGS //////////

  Settings1.Auto.Checked := Config.Auto;
  Settings1.refresh.Text := inttostr(RefreshTimer.Interval div 1000);
  Settings1.mintotray.Checked := Config.mintotray;
  Settings1.sortrefresh.Checked := Config.sortrefresh;
  Settings1.autoupdate.Checked := Config.autoupdate;
  Settings1.PlayersOnTab.Checked := Config.PlayersOnTab;
  Settings1.updatefreq.ItemIndex := Config.updatefreq;
  Settings1.AdminName.Text := Config.AdminName;
  Settings1.SoundfileName.Text := Config.SoundfileName;
  Settings1.AdminChat.Selected := Config.ColorAdmChat;
  Settings1.Chat.Selected := Config.ColorChat;
  Settings1.mainConsole.Selected := Config.ColorMain;
  Settings1.mutedChat.Selected := Config.ColorMuted;
  Settings1.normalText.Selected := Config.ColorText;
  Settings1.PM.Selected := Config.ColorPm;
  Settings1.Say.Selected := Config.ColorAdmin;
  Settings1.teamChat.Selected := Config.ColorTeam;
  Settings1.clientList.Selected := Config.ColorClientList;

  Settings1.FontButton.Caption := Memo.Font.Name;

  Settings1.CustomColorList.Clear;
  for i := 0 to Config.CustomColors.Count - 1 do
  begin
    Settings1.CustomColorList.Items.Add;
    Settings1.CustomColorList.Items.Item[Settings1.CustomColorList.Items.Count -
      1].Caption := Config.CustomColors.Names[i];
    Settings1.CustomColorList.Items.Item[Settings1.CustomColorList.Items.Count -
      1].SubItems.Add(Config.CustomColors.ValueFromIndex[i]);
  end;

  ////////////// SERVER SPECIFIC SETTINGS //////////

  Settings1.savepass.Checked := ServerList[ServerTab.TabIndex].Config.savepass;
  Settings1.savelog.Checked := ServerList[ServerTab.TabIndex].Config.savelog;
  // Settings1.savelog.Caption:= 'save message log to "logs\' + ServerTab.Tabs[ServerTab.TabIndex] + '.txt"';
  Settings1.savelog.Caption := 'save message log to "logs\' +
    ServerList[ServerTab.TabIndex].ServerName + '.log\"';
  Settings1.autoswap.Checked := ServerList[ServerTab.TabIndex].Config.autoswap;
  Settings1.autobalance.Checked :=
    ServerList[ServerTab.TabIndex].Config.autobalance;
  Settings1.hideRegistered.Checked :=
    ServerList[ServerTab.TabIndex].Config.hideRegistered;
  Settings1.hideKills.Checked :=
    ServerList[ServerTab.TabIndex].Config.hideKills;
  Settings1.balancediff.Text :=
    inttostr(ServerList[ServerTab.TabIndex].Config.balancediff);

  Settings1.autosay.Checked := ServerList[ServerTab.TabIndex].AutoSay.Enabled;
  Settings1.AutoMsgTime.Text :=
    inttostr(ServerList[ServerTab.TabIndex].AutoSay.Interval div 1000);

  Settings1.AutoMsgList.Clear;
  Settings1.AutoMsgList.Lines.AddStrings(ServerList[ServerTab.TabIndex].Config.AutoMessageList);
  // Settings1.scrolling.Checked:= Config.gorgetes;
  // Settings1.ingCmd.Checked:= Config.ingcmd;

  /////////// Timer Adatok Bet�lt�se /////////

  Settings1.TimerList.Clear;
  with ServerList[ServerTab.TabIndex] do
    for i := 0 to TimerName.Count - 1 do
    begin
      item := Settings1.TimerList.Items.Add;
      item.Caption := TimerName[i];
      item.Checked := Timers[i].Timer.Enabled;
      item.Subitems.Add(inttostr(Timers[i].Loop));
      item.Subitems.Add(inttostr(Timers[i].Timer.Interval div 1000));
      item.Subitems.Add(Timers[i].ScriptFile);
    end;

  Settings1.EventList.Clear;
  for i := 0 to EVENTCOUNT do
  begin
    if (i = 0) or (i = 1) then
    begin
      item := Settings1.EventList.Items.Add;
      item.Caption := Config.Events[i];
      item.Checked := Config.EventOn[i];
      item.SubItems.Add(Config.EventFile[i]);
    end
    else if (i > proba) then
    begin
      item := Settings1.EventList.Items.Add;
      item.Caption := Config.Events[i - proba2];
      item.Checked := Config.EventOn[i - proba2];
      item.SubItems.Add(Config.EventFile[i - proba2]);
    end
    else
    begin
      item := Settings1.EventList.Items.Add;
      item.Caption := ServerList[ServerTab.TabIndex].Config.Events[i];
      item.Checked := ServerList[ServerTab.TabIndex].Config.EventOn[i];
      item.SubItems.Add(ServerList[ServerTab.TabIndex].Config.EventFile[i]);
    end;
  end;

  Settings1.HotkeyList.Clear;
  for i := 0 to Config.HotkeyDescription.Count - 1 do
  begin
    item := Settings1.HotkeyList.Items.Add;
    item.Caption := Config.Hotkeys[i].Text;
    item.SubItems.Add(Config.HotkeyDescription[i]);
    HotkeyShift[i] := Config.Hotkeys[i].Shift;
    HotkeyNumber[i] := Config.Hotkeys[i].Key;
  end;

  if Settings1.ShowModal = mrOK then
  begin

    with Settings1 do
    begin
      Config.IRC.Server := IRCServer.Text;
      Config.IRC.Port := strtoint(IRCPort.Text);
      Config.IRC.Nick := IRCNick.Text;
      Config.IRC.AltNick := IRCAltNick.Text;
      Config.IRC.Username := IRCUsername.Text;
      Config.IRC.Channel := IRCChannel.Text;
      Config.IRC.ChanKey := IRCKey.Text;
      Config.IRC.Prefix := Prefix.Text;
      Config.IRC.auth := QNetAuth.Checked;
      Config.IRC.ANick := QNetUser.Text;
      Config.IRC.APass := QNetPass.Text;
      Config.IRC.ABot := QNetBot.Text;
      Config.IRC.ACmd := QNetCmd.Text;
    end;

    Config.Auto := Settings1.Auto.Checked;
    Config.mintotray := Settings1.mintotray.Checked;
    Config.sortrefresh := Settings1.sortrefresh.Checked;
    Config.autoupdate := Settings1.autoupdate.Checked;
    Config.updatefreq := Settings1.updatefreq.ItemIndex;
    Config.PlayersOnTab := Settings1.PlayersOnTab.Checked;
    RefreshTimer.Interval := strtoint(Settings1.refresh.Text) * 1000;

    Config.AdminName := Settings1.AdminName.Text;
    Config.SoundfileName := Settings1.SoundfileName.Text;
    Config.ColorAdmChat := Settings1.AdminChat.Selected;
    Config.ColorChat := Settings1.Chat.Selected;
    Config.ColorMuted := Settings1.mutedChat.Selected;
    Config.ColorPm := Settings1.PM.Selected;
    Config.ColorAdmin := Settings1.Say.Selected;
    Config.ColorTeam := Settings1.teamChat.Selected;
    Config.ColorClientList := Settings1.clientList.Selected;

    if (Config.ColorMain <> Settings1.mainConsole.Selected) or (Config.ColorText
      <> Settings1.normalText.Selected) then
      for i := 0 to ServerTab.Tabs.Count - 1 do
      begin
        ServerList[i].Memo.Color := Settings1.mainConsole.Selected;
        ServerList[i].Memo.Font.Color := Settings1.normalText.Selected;
      end;

    if Memo.Font.Name <> Settings1.FontButton.Caption then
      for i := 0 to ServerTab.Tabs.Count - 1 do
      begin
        ServerList[i].Memo.Font.Name := Settings1.FontButton.Caption;
      end;
    Memo.Font.Name := Settings1.FontButton.Caption;

    Config.ColorMain := Settings1.mainConsole.Selected;
    Config.ColorText := Settings1.normalText.Selected;

    Config.CustomColors.Clear;
    for i := 0 to Settings1.CustomColorList.Items.Count - 1 do
    begin
      Config.CustomColors.Add(Settings1.CustomColorList.Items.Item[i].Caption +
        '=' +
        Settings1.CustomColorList.Items.Item[i].SubItems[0]);
    end;

    ServerList[ServerTab.TabIndex].Config.savepass :=
      Settings1.savepass.Checked;
    ServerList[ServerTab.TabIndex].Config.savelog := Settings1.savelog.Checked;

    ServerList[ServerTab.TabIndex].Config.autoswap :=
      Settings1.autoswap.Checked;
    ServerList[ServerTab.TabIndex].Config.autobalance :=
      Settings1.autobalance.Checked;
    ServerList[ServerTab.TabIndex].Config.balancediff :=
      strtoint(Settings1.balancediff.Text);
    if ServerList[ServerTab.TabIndex].Config.balancediff < 2 then
      ServerList[ServerTab.TabIndex].Config.balancediff := 2;

    ServerList[ServerTab.TabIndex].Config.AutoMessageList.Clear;
    ServerList[ServerTab.TabIndex].Config.AutoMessageList.AddStrings(Settings1.AutoMsgList.Lines);

    ServerList[ServerTab.TabIndex].AutoSay.Enabled := Settings1.autosay.Checked;
    ServerList[ServerTab.TabIndex].AutoSay.Interval :=
      strtoint(Settings1.AutoMsgTime.Text) * 1000;

    //  ServerList[ServerTab.TabIndex].Config.gorgetes:= Settings1.scrolling.Checked;
    ServerList[ServerTab.TabIndex].Config.hideRegistered :=
      Settings1.hideRegistered.Checked;
    ServerList[ServerTab.TabIndex].Config.hideKills :=
      Settings1.hideKills.Checked;
    //Config.ingCmd:= Settings1.ingcmd.Checked;

    for i := 0 to EVENTCOUNT do
    begin
      if (i = 0) or (i = 1) then
      begin
        Config.EventFile[i] := Settings1.EventList.Items[i].SubItems[0];
        Config.EventOn[i] := Settings1.EventList.Items[i].Checked;
      end
      else if (i > proba) then
      begin
        Config.EventFile[i - proba2] :=
          Settings1.EventList.Items[i].SubItems[0];
        Config.EventOn[i - proba2] := Settings1.EventList.Items[i].Checked;
      end
      else
      begin
        ServerList[ServerTab.TabIndex].Config.EventFile[i] :=
          Settings1.EventList.Items[i].SubItems[0];
        ServerList[ServerTab.TabIndex].Config.EventOn[i] :=
          Settings1.EventList.Items[i].Checked;
      end;
    end;

  end; //if OK

  SetFocusToCmd(Form1);
end;

function GetRect(thisRect: TRect): TRect;
begin
  result := Rect(thisRect.left + form1.PlayerList.Columns[0].Width + 2,
    thisRect.Top,
    thisRect.left + form1.PlayerList.Columns[0].Width + 2 + 16,
    thisRect.Top + 16);
end;

procedure TForm1.PlayerListCustomDrawSubItem(Sender: TCustomListView;
  Item: TListItem; SubItem: Integer; State: TCustomDrawState;
  var DefaultDraw: Boolean);
var
  drawingrect: TRect;
  lv: TListView;
  cid, i: Integer;
  w: Integer;
begin
  //set playerlist id backgroundcolor
  if Item.SubItems[ITEM_TEAM] = 'Alpha' then
    Sender.Canvas.Brush.Color := $F2F2FF
  else if Item.SubItems[ITEM_TEAM] = 'Bravo' then
    Sender.Canvas.Brush.Color := $FFF4F2
  else if Item.SubItems[ITEM_TEAM] = 'Charlie' then
    Sender.Canvas.Brush.Color := $E5FAFF
  else if Item.SubItems[ITEM_TEAM] = 'Delta' then
    Sender.Canvas.Brush.Color := $E8FFE5
  else if Item.SubItems[ITEM_TEAM] = 'Spectator' then
    Sender.Canvas.Brush.Color := $FFF2FA
  else if Item.SubItems[ITEM_TEAM] = 'None' then
    Sender.Canvas.Brush.Color := clWhite;

  if Subitem = COLUMN_NAME then //draw player flags with name
  begin
    DefaultDraw := false;
    lv := TListView(Sender);
    try
      w := -GetScrollPos(Sender.Handle, SB_HORZ);

      for i := COLUMN_ID to COLUMN_NUM do
      begin
        begin
          if lv.Column[i].Tag = SubItem then
            break
          else if columnsVisibility[lv.Column[i].Tag] = true then
            w := w + lv.Column[i].Width;
        end;
      end;

      drawingrect := Item.DisplayRect(drSelectBounds);
      drawingrect.Left := drawingrect.Left + w;

      if (lv.Selected <> nil) and (lv.Selected.Index = Item.Index) then
      begin
        if lv.Focused then
        begin
          lv.Canvas.Brush.Color := clHighlight;
          lv.Canvas.Font.Color := clHighlightText;
        end
        else
        begin
          lv.Canvas.Brush.Color := clMenuBar;
          lv.Canvas.Font.Color := clBtnText;
        end;
      end;

      Sender.Canvas.FillRect(drawingrect);

      try
        cid :=
          ServerList[ServerTab.TabIndex].playerFlag[StrToInt(Item.Caption)];
        Sender.Canvas.Draw(w + 2, (drawingrect.Bottom - drawingrect.Top -
          CountryFlags[cid].Height) div 2 + drawingrect.Top,
          CountryFlags[cid]);
        Sender.Canvas.TextOut(w + 2 + CountryFlags[cid].Width + 2, drawingrect.Top,
          Item.SubItems[ITEM_NAME]);
      except
        Sender.Canvas.TextOut(w + 2 + 0 + 2, drawingrect.Top, Item.SubItems[ITEM_NAME]);
      end;
    finally
    end;
  end
  else if Subitem = COLUMN_PING then
  begin
    if strtoint(Item.SubItems[ITEM_PING]) < 100 then
      Sender.Canvas.Font.Color := clGreen;
    if (strtoint(Item.SubItems[ITEM_PING]) < 300) and
      (strtoint(Item.SubItems[ITEM_PING]) >= 100) then
      Sender.Canvas.Font.Color := clOlive;
    if strtoint(Item.SubItems[ITEM_PING]) >= 300 then
      Sender.Canvas.Font.Color := clRed;
  end

  else if Subitem = COLUMN_TEAM then
  begin
    if Item.SubItems[ITEM_IP] = 'Bot' then //darker bot teamcolors
    begin
      if Item.SubItems[ITEM_TEAM] = 'Alpha' then
        Sender.Canvas.Font.Color := clMaroon;
      if Item.SubItems[ITEM_TEAM] = 'Bravo' then
        Sender.Canvas.Font.Color := clNavy;
      if Item.SubItems[ITEM_TEAM] = 'Charlie' then
        Sender.Canvas.Font.Color := $00006262;
      if Item.SubItems[ITEM_TEAM] = 'Delta' then
        Sender.Canvas.Font.Color := $003F00;
      if Item.SubItems[ITEM_TEAM] = 'Spectator' then
        Sender.Canvas.Font.Color := $3F3F3F;
      if Item.SubItems[ITEM_TEAM] = 'None' then
        Sender.Canvas.Font.Color := clPurple;
    end
    else
    begin
      if Item.SubItems[ITEM_TEAM] = 'Alpha' then
        Sender.Canvas.Font.Color := clRed;
      if Item.SubItems[ITEM_TEAM] = 'Bravo' then
        Sender.Canvas.Font.Color := clBlue;
      if Item.SubItems[ITEM_TEAM] = 'Charlie' then
        Sender.Canvas.Font.Color := clOlive;
      if Item.SubItems[ITEM_TEAM] = 'Delta' then
        Sender.Canvas.Font.Color := clGreen;
      if Item.SubItems[ITEM_TEAM] = 'Spectator' then
        Sender.Canvas.Font.Color := clGray;
      if Item.SubItems[ITEM_TEAM] = 'None' then
        Sender.Canvas.Font.Color := clBlack;
    end;
  end

  else
  begin
    Sender.Canvas.Font.Color := clBlack;
  end

end;

procedure TForm1.FormResize(Sender: TObject);
//var tav: integer;
begin
  TeamList.Width := 150;
  InfoBox.Width := TeamList.Width + 1;
  Action.Width := TeamList.Width + 1;
  //PerformAction.Width := Action.Width - 16;

  //tav:= Form1.Height-Form1.ClientHeight;
  //  ServerList[ServerTab.TabIndex].Memo.Lines.Add(inttostr(Form1.ClientHeight));
  //  ServerList[ServerTab.TabIndex].Memo.Lines.Add(inttostr(Form1.Height));

  Panel2.Width := Form1.ClientWidth - Panel2.Left;
  Panel3.Width := Form1.ClientWidth - Panel3.Left;
  Panel3.Top := Form1.ClientHeight - Panel3.Height;
  Panel4.Left := Form1.ClientWidth - Panel4.Width;
  Panel4.Height := Form1.ClientHeight - Panel4.Top;

  PageControl.Height := Form1.ClientHeight - PageControl.Top;
  PageControl.Width := Form1.ClientWidth - PageControl.Left;

  Action.Left := Form1.Width - Action.Width - 10 - 24;
  Action.Height := Form1.ClientHeight - Action.Top - 2 ;//- 25;
  //PerformAction.Top := Action.Height - 26;

  ActionList.Items.BeginUpdate;
  ActionList.Width := Action.Width - 16;
  ActionList.Height := Action.Height - 45;
  ActionList.Left := Action.Left + 8;
  ActionList.Items.EndUpdate;

  // try
  ServerList[ServerTab.TabIndex].Memo.Width := Action.Left - 7;
  Memo.Width := Action.Left - 7;
  if ServerList[ServerTab.TabIndex].Memo.Height =
    ServerList[ServerTab.TabIndex].Memo.Constraints.MinHeight then
  begin
    ServerList[ServerTab.TabIndex].Memo.Height :=
      ServerList[ServerTab.TabIndex].Memo.Constraints.MinHeight + 1;
    if PlayerList.Height > PlayerList.Constraints.MinHeight then
    begin
      ServerList[ServerTab.TabIndex].Memo.Top := Form1.ClientHeight - 39 -
        ServerList[ServerTab.TabIndex].Memo.ClientHeight -
        30; //-25;
      PlayerList.Height := ServerList[ServerTab.TabIndex].Memo.Top - 58;
      //-63-27+24;
      Panel1.Top := PlayerList.Top + PlayerList.Height;
    end;
  end;
  //  else;
  ServerList[ServerTab.TabIndex].Memo.Height := Form1.ClientHeight -
    PageControl.Top - ServerList[ServerTab.TabIndex].Memo.Top
    - 43; //Form1.Height - ServerList[ServerTab.TabIndex].Memo.Top -  68 -31;
  Memo.Height := Form1.ClientHeight - PageControl.Top -
    ServerList[ServerTab.TabIndex].Memo.Top - 43;
  //Form1.Height - ServerList[ServerTab.TabIndex].Memo.Top -  68 -31;
// except
// end;

  Cmd.Top := Form1.ClientHeight - Cmd.Height - 3 - 25;
  //  Help.Left:= Cmd.Width+7;
  //  Help.Top:= Cmd.Top+4;
  //  Label5.Left:= Cmd.Width+7;
  //  Label5.Top:= Cmd.Top-12;
  Label1.Top := Cmd.Top - 14;
  SayBox.Top := Label1.Top;
  NickSayBox.Top := Label1.Top;
  AdminBox.Top := Label1.Top;

  PlayerList.Width := Action.Left - 7;
  Cmd.Width := PlayerList.Width;
  Panel1.Width := PlayerList.Width - 1;
  InfoBox.Left := Form1.Width - InfoBox.Width - 10 - 24;
  if infoON then
    InfoBox.Height := Action.Top - InfoBox.Top + Action.Height;
  //GroupBox3.Left:= Form1.Width-GroupBox3.Width-10-24;
  TeamList.Left := Form1.Width - TeamList.Width - 11 - 24;
  GroupBox2.Width := Form1.Width - 10 - 24;
  SayBox.Left := Cmd.Left + Cmd.Width - SayBox.Width;
  NickSayBox.Left := Cmd.Left + Cmd.Width - NickSayBox.Width - SayBox.Width;
  AdminBox.Left := Cmd.Left + Cmd.Width - AdminBox.Width - NickSayBox.Width -
    SayBox.Width;

  ServerTab.Width := Form1.ClientWidth - 120;
  RemoveServer.Left := ServerTab.Width + 24;
  AddServer.Left := RemoveServer.Left + RemoveServer.Width + 5;

  ///  IRC Bot resize ////

  //  GroupBox4.Width:= Form1.Width-10-24;
  IRCConsole.Width := Form1.Width - 12 - 24 - UserBox.Width - 24;
  IRCConsole.Height := Form1.ClientHeight - PageControl.Top - IRCConsole.Top -
    43;

  UserBox.Left := IRCConsole.Width + 1;
  UserBox.Height := IRCConsole.Height;
  Label10.Top := IRCConsole.Height + IRCConsole.Top - 0;
  IRCCmd.Top := Label10.Top + 14;
  IRCCmd.Width := IRCConsole.Width;

end;

procedure TForm1.FormConstrainedResize(Sender: TObject; var MinWidth,
  MinHeight, MaxWidth, MaxHeight: Integer);
begin
  // MinWidth:= 722;
  // MinHeight:= 248+29;
end;

procedure TForm1.WMSIZE(var Msg: TWMSIZE);
begin
  if Msg.SizeType = Integer(wsMaximized) then
  begin
    Maximized := True;

    NormalX := _NormalX;
    NormalY := _NormalY;
  end
  else if Msg.SizeType = Integer(wsNormal) then
  begin
    Maximized := False;

    _NormalX := NormalX;
    _NormalY := NormalY;
    NormalX := Form1.Left;
    NormalY := Form1.Top;

    NormalWidth := Form1.Width;
    NormalHeight := Form1.Height;
  end;
  Invalidate;
  inherited;
end;

procedure TForm1.FormMove(var Msg: TWMMove);
begin
  if Form1.WindowState = wsNormal then
  begin
    _NormalX := NormalX;
    _NormalY := NormalY;
    NormalX := Form1.Left;
    NormalY := Form1.Top;
  end;
  inherited;
end;

// BenneVan means Matches. It looks for the Mask in a string.
// For example: Matches('/say *',string) will return true
//  if the string is something like '/say hello!'.

function TForm1.Matches(Mask, S: string): Boolean;
var
  i: Integer;
begin
  if Length(Mask) = 0 then
    Result := Length(S) = 0
  else
  begin
    Result := False;
    case Mask[1] of
      '*': for i := 1 to Length(S) + 1 do
        begin
          Result := Matches(Copy(Mask, 2, MaxInt), Copy(S, i, MaxInt));
          if Result then
            Exit;
        end;
      '?':
        begin
          Result := Length(S) > 0;
          if not Result then
            Exit;
          Result := Matches(Copy(Mask, 2, MaxInt), Copy(S, 2, MaxInt));
        end;
    else
      begin
        Result := Mask[1] = Copy(S, 1, 1);
        if not Result then
          Exit;
        Result := Matches(Copy(Mask, 2, MaxInt), Copy(S, 2, MaxInt));
      end;
    end;
  end;
end;

procedure TForm1.SwapTeams(swapkind: byte; index: integer);
var
  i: integer;
begin
  case swapkind of
    0:
      begin
        if (ServerList[index].RefreshMsg.GameStyle = 3) or
          (ServerList[index].RefreshMsg.GameStyle = 5) then
        begin
          for i := 1 to MAX_PLAYERS do
            if ServerList[index].RefreshMsg.Team[i] < 6 then
            begin
              if ServerList[index].RefreshMsg.Team[i] = 1 then
                ServerList[index].Client.WriteLn('/setteam2 ' +
                  inttostr(ServerList[index].RefreshMsg.Number[i]));
              if ServerList[index].RefreshMsg.Team[i] = 2 then
                ServerList[index].Client.WriteLn('/setteam1 ' +
                  inttostr(ServerList[index].RefreshMsg.Number[i]));
            end;
          ServerList[index].Client.WriteLn('/say Teams Swapped.');
        end
        else
          exit;
      end;

    1:
      begin
        if (ServerList[index].RefreshMsg.GameStyle = 3) or
          (ServerList[index].RefreshMsg.GameStyle = 5) then
        begin
          for i := 1 to MAX_PLAYERS do
            if ServerList[index].RefreshMsg.Team[i] < 6 then
            begin
              if (i mod 2) = 1 then
                ServerList[index].Client.WriteLn('/setteam1 ' +
                  inttostr(ServerList[index].RefreshMsg.Number[i]));
              if (i mod 2) = 0 then
                ServerList[index].Client.WriteLn('/setteam2 ' +
                  inttostr(ServerList[index].RefreshMsg.Number[i]));
            end;
          ServerList[index].Client.WriteLn('/say Teams balanced.');
        end
        else
          exit;

      end;

  end;

end;

procedure TForm1.ARSSETimerTimer(Sender: TObject);
var
  i, j: shortint;
begin
  for i := 0 to ServerTab.Tabs.Count - 1 do
    with ServerList[i] do
      for j := 0 to TimerName.Count - 1 do
        if (Sender as TTimer).ComponentIndex = Timers[j].Timer.ComponentIndex
          then
        begin
          if not ServerList[i].Client.Connected then
            exit;
          {      if Timers[j].Timer.Enabled then ShowMessage('WEeeee')
                else  ShowMessage('Bruuuuu');
                }
          EventOccure('', //'$SERVER_NAME$SERVER_IP$SERVER_PORT',
            '', //ServerTab.Tabs[i] +''+ServerList[j].Client.Host+''+inttostr(ServerList[j].Client.Port),
            Timers[j].ScriptFile, i);
          if Timers[j].Loop = 1 then {RemoveTimer(i,j)}
            Timers[j].Timer.Enabled := false
          else if Timers[j].Loop <> 0 then
            dec(Timers[j].Loop);
          //      exit;
        end;

end;

procedure TForm1.AutoSayTimer(Sender: TObject);
var
  i, j: shortint;
begin
  for i := 0 to ServerTab.Tabs.Count - 1 do
    if (Sender as TTimer).ComponentIndex = ServerList[i].AutoSay.ComponentIndex
      then
      try
        if ServerList[i].Client.Connected then
          for j := 0 to ServerList[i].Config.AutoMessageList.Count - 1 do
            ServerList[i].Client.WriteLn('/say ' +
              ServerList[i].Config.AutoMessageList[j]);
      except
      end;

  {  ///////// OLD METHOD //////////

  for j:=0 to ServerTab.Tabs.Count-1 do
   if ServerList[j].Client.Connected then // exit;

   try
    for i:= 0 to  Config.AutoMessageList.Count-1 do
       ServerList[j].Client.WriteLn('/say ' + Config.AutoMessageList[i]);  //Settings1.AutoMsgList.Lines[i]);
   except
   end;
  }
end;

procedure TForm1.PlayerName1Click(Sender: TObject);
begin
  Clipboard.SetTextBuf(PChar(PlayerList.Items[PlayerList.Itemindex].Subitems[ITEM_NAME]));
end;

procedure TForm1.PlayerIP1Click(Sender: TObject);
begin
  Clipboard.SetTextBuf(PChar(PlayerList.Items[PlayerList.Itemindex].Subitems[ITEM_IP]));
end;

//handles the clearing of nickcompletion list
//and reseting of tabpresscount

procedure TForm1.FormShortCut(var Msg: TWMKey; var Handled: Boolean);
var
  i, insertpos: integer;
  firstentry: boolean;
  firsthalf, secondhalf, nicktext: string;
begin

  if (Msg.CharCode = VK_TAB) and Ctrl then
  begin
    Handled := false;
    if PlayerList.Enabled and (ActiveControl = Cmd) then
      PlayerList.SetFocus;
    Msg.CharCode := 0;
    exit;
  end;

  if ActiveControl = Cmd then
    if Msg.CharCode = VK_TAB then //maybe other keys are useful too (review)
    begin
      Handled := true;
      //we need to look at the list and oh we need the last command (nickname)
      insertpos := cmd.selstart;

      //exclude negative positons
      if (Length(cmd.text) > 0) then
      begin

        //check if we already completed the nick and hit tab another time
        nicktext := copy(cmd.text, cmd.SelStart + 1 - Length(completednick),
          Length(completednick));
        if (nicktext = completednick) and (nickcompletionlist.Count > 1) then
        begin //get next entry form the list and paste it
          tabpresscount := tabpresscount + 1;
          if tabpresscount > (nickcompletionlist.Count - 1) then
            tabpresscount := 0;
          //we cycled through the complete list so lets go to 1. entry
      //replacing of writtentext
      //copy the first half of the whole text
          firsthalf := Copy(cmd.text, 0, cmd.SelStart - Length(completednick));
          //copy the second half of the whole text
          secondhalf := Copy(cmd.text, cmd.SelStart + 1, Length(cmd.text) -
            (cmd.selstart));
          //save our nick
          completednick := nickcompletionlist[tabpresscount];
          //put it together
          cmd.text := firsthalf + completednick + secondhalf;
          //fix the selstart position
          cmd.selstart := Length(firsthalf) + Length(completednick);
          exit;
        end;

        //exclude calling on spaces
        if (cmd.text[insertpos] <> ' ') then
        begin
          //find the space
          for insertpos := cmd.selstart downto 1 do
            if cmd.text[insertpos] = ' ' then
            begin
              break;
            end;

          nicktext := copy(cmd.text, insertpos + 1, (cmd.selstart) - insertpos);
          firstentry := true;
          nickcompletionlist.Clear;
          //reset tabpresscount to be able call it again and get the second nick
          tabpresscount := 0;
          for i := 0 to PlayerList.Items.Count - 1 do
          begin
            //compare with nicknames
            if Matches(ansilowercase(nicktext) + '*',
              ansilowercase(PlayerList.Items[i].Subitems[ITEM_NAME])) then
              //maybe not sorted by playernames!
            begin
              if firstentry then
              begin
                firstentry := false;
                //copy the first half of the whole text
                firsthalf := Copy(cmd.text, 0, insertpos);
                //copy the second half of the whole text
                secondhalf := Copy(cmd.text, cmd.selstart + 1, Length(cmd.text)
                  - (cmd.selstart));
                //save your nick
                completednick := PlayerList.Items[i].Subitems[ITEM_NAME] + ' ';
                //put it together
                cmd.text := firsthalf + completednick + secondhalf;
                //fix the selstart position
                cmd.selstart := Length(firsthalf) + Length(completednick);
              end;
              //add nickname in the list
              nickcompletionlist.add(PlayerList.Items[i].Subitems[ITEM_NAME] + ' ');
            end;
          end;
        end;
      end;
    end
    else
    begin
      //clear nicklist when keys are added to the cmd.text
      nickcompletionlist.Clear;
      tabpresscount := 0;
    end;

end;

procedure TForm1.UMNotifyIcon(var Msg: TMessage);
var
  uID: integer;
  uMouseMsg: integer;
begin
  uID := Msg.wParam;
  uMouseMsg := Msg.lParam;
  if uID = MYTRAYICONID then // we may have created more than one icon
    case uMouseMsg of
      WM_LBUTTONDOWN:
        ; // do something else
      WM_LBUTTONDBLCLK:
        RestoreMainForm;
      WM_RBUTTONDOWN:
        ShowThePopup; //
      //        ...
    end;
end;

procedure TForm1.SwapTimerTimer(Sender: TObject);
var
  i: shortint;
begin
  for i := 0 to ServerTab.Tabs.Count - 1 do
    if (Sender as TTimer).ComponentIndex = ServerList[i].SwapTimer.ComponentIndex
      then
      try
        SwapTeams(0, i);
        ServerList[i].SwapTimer.Enabled := false;
      except
      end;

end;

procedure TForm1.OnPlayerJoin(var Name, ip: string; index: integer);
var
  f: textfile;
  sor: string;
  // inif: boolean;
begin
  inif := false;
  //  regular:= true;

  // Start of Named Bans

  if fileexists(ExtractFilePath(Application.ExeName) + 'bannames.txt') then
  begin
    AssignFile(f,ExtractFilePath(Application.ExeName) +  'bannames.txt');
    try
      Reset(F);
      try

        while not Eof(f) do
        begin
          ReadLn(F, sor);
          if Matches(sor, Name) then
          begin
            try
              ServerList[index].Client.WriteLn('/kick ' + sor);
              //ServerList[ServerTab.TabIndex].Client.WriteLn('/banip ' + ip);
            except
            end;
            break;
          end;
        end;
      except
      end;
    finally
      CloseFile(F);
    end;
  end;

  // End of Named Bans

  if not ServerList[index].Config.EventOn[5] then
    exit;

  /// OnPlayerJoin script

  EventOccure('$PLAYER_NAME$PLAYER_IP$SERVER_IP$SERVER_PORT', Name + '' + ip
    + '' + ServerList[index].Client.Host + '' +
    inttostr(ServerList[index].Client.Port),
    ServerList[index].Config.EventFile[5], index);

  {
    if fileexists(ExtractFilePath(Application.ExeName) + 'script/'+Settings1.EventList.Items[5].SubItems[0]+'.txt') then
  begin
   AssignFile(f, ExtractFilePath(Application.ExeName) + 'script/'+Settings1.EventList.Items[5].SubItems[0]+'.txt');
   Try
    Reset(F);
   Try

   while not Eof(f) do
    begin
     ReadLn(F,sor);

     if Matches('/*',sor) and inif then
     begin
       if Matches('*$PLAYER_NAME*',sor) then
       begin
        Insert(Name,sor,Pos('$PLAYER_NAME',sor));
        Delete(sor,Pos('$PLAYER_NAME',sor),Length('$PLAYER_NAME'));
       end;

       ServerList[ServerTab.TabIndex].Client.WriteLn(sor);
     end;

     if Matches('endif',sor) and inif then
     begin
       inif:= false;
  //     regular:= true;
     end; //endif �s inif

     if Matches('else',sor) and not inif then
     begin
       inif:= true;
  //     regular:= true;
     end; //endif �s inif

     if Matches('if *',sor) and not inif then
     begin
      Delete(sor,1,2);
      while Pos(' ',sor) = 1 do Delete(sor,1,1);
      while sor[length(sor)] = ' ' do Delete(sor,Length(sor),1);

      if Matches('$PLAYER_NAME*',sor) then
      begin
       Delete(sor,1,Length('$PLAYER_NAME'));
       if Matches('*=*',sor) then
       begin
        Delete(sor,1,Pos('=',sor));
        while Pos(' ',sor) = 1 do Delete(sor,1,1);
        if Matches(sor,Name) then
        begin
         inif:= true;
  //       regular:= false;
        end;
        //ServerList[ServerTab.TabIndex].Memo.Lines.Add(sor+' vs. '+Name);
       end;
      end;
     end;//Matches 'if' sor

     //break;
    end;
   Except
   end;
   Finally
   CloseFile(F);
   end;
  end;
  }

end;

procedure TForm1.Name1Click(Sender: TObject);
var
  i: integer;
  S: string;
  ch: char;
begin
  if PlayerList.Items.Count = 0 then
    exit;
  i := PlayerList.Itemindex;
  if (i < 0) or (i > (PlayerList.Items.Count - 1)) then
    exit;

  S := PlayerList.Items[i].Caption;

  Cmd.Text := '/kick ' + S;
  ch := #13;
  CmdKeyPress(nil, ch);

  S := PlayerList.Items[i].SubItems[ITEM_NAME];

  AddToBanList(S, true);
end;

procedure TForm1.AddToBanList(var Name: string; const Ban: boolean);
var
  f: textfile;
  Names: TStringList;
  seged: string;
  i: integer;
  found: boolean;
begin
  if (not Ban) and (not fileexists(ExtractFilePath(Application.ExeName) + 'bannames.txt')) then
    exit;

  Names := TStringList.Create;
  found := false;

  AssignFile(F, ExtractFilePath(Application.ExeName) + 'bannames.txt');
  if not fileexists(ExtractFilePath(Application.ExeName) + 'bannames.txt') then
    Rewrite(F)
  else if Ban then
    Append(F)
  else
    Reset(F);

  try
    try
      if Ban then
      begin
        WriteLn(F, Name);
        ServerList[ServerTab.TabIndex].Client.WriteLn(Name +
          ' has been added to banned names list.');
      end
      else
      begin
        while not EOF(F) do
        begin
          ReadLn(F, seged);
          if seged <> Name then
            Names.Add(seged)
          else
            found := true;
        end;
        if found then
          ServerList[ServerTab.TabIndex].Client.WriteLn(Name +
            ' has been removed from banned names list.');
      end;
    except
    end;
  finally
    CloseFile(F);
  end;

  if not Ban then
  begin

    AssignFile(F, ExtractFilePath(Application.ExeName) + 'bannames.txt');
    Rewrite(F);
    for i := 0 to Names.Count - 1 do
      WriteLn(F, Names[i]);
    CloseFile(F);

  end;
  Names.Free;
end;

procedure TForm1.DoRefresh();
var
  P_Teams: array[1..5] of shortint;
  j: Integer;
  i, k, h, id, m, players {, bots, specs}: shortint;
  perc, masodperc: integer;
  teammode: byte;
  kd, AvgP, TScore, TDeaths: double;
  newplayer, found: boolean;
  //  seged: string;
begin
  //  ServerList[ServerTab.TabIndex].Memo.Lines.Add( booltostr( ServerList[ServerTab.TabIndex].Client.Connected));
  if not ServerList[ServerTab.TabIndex].Client.Connected then
    exit;

  //  ServerList[ServerTab.TabIndex].Memo.Lines.Add(inttostr(ServerTab.TabIndex));

  newplayer := false;
  AvgP := 0;
  TScore := 0;
  TDeaths := 0;
  players := 0;
  ServerList[ServerTab.TabIndex].bots := 0;
  ServerList[ServerTab.TabIndex].specs := 0;
  //  ServerList[ServerTab.TabIndex].players:= 0;

  for i := 1 to 5 do
    P_Teams[i] := 0;
  //Memo.Lines.Add('Receiving server state...');

  if PlayerList.Items.Count = 0 then
  begin
    for i := 1 to MAX_PLAYERS do
    begin
      with ServerList[ServerTab.TabIndex] do
      begin
        if (RefreshMsg.Team[i] < 6) and (RefreshMsg.Number[i] < 33)
          and (RefreshMsg.Number[i] > 0) then
        begin
          inc(P_Teams[RefreshMsg.Team[i]]);
          k := i;
          AddPlayersToList(k);
          //tabswitched or players are already in the server when connecting first time
          //check player is still the same
          id := RefreshMsg.Number[k];
          if (not ((RefreshMsg.IP[k][1] = LastIP[id][1]) and
            (RefreshMsg.IP[k][2] = LastIP[id][2]) and
            (RefreshMsg.IP[k][3] = LastIP[id][3]) and
            (RefreshMsg.IP[k][4] = LastIP[id][4]))) then
          begin
            //if not then update
            for m := 1 to 4 do
            begin
              LastIP[id][m] := RefreshMsg.IP[k][m];
            end;
            playerFlag[id] := DBFile.GetFlagId(RefreshMsg.IP[k][1],
              RefreshMsg.IP[k][2], RefreshMsg.IP[k][3], RefreshMsg.IP[k][4]);
          end;
          if ((RefreshMsg.IP[k][1] = 0) and (RefreshMsg.IP[k][2] = 0) and
            (RefreshMsg.IP[k][3] = 0) and (RefreshMsg.IP[k][4] = 0)) then
            playerFlag[id] := DBFile.GetFlagId(RefreshMsg.IP[k][1],
              RefreshMsg.IP[k][2], RefreshMsg.IP[k][3], RefreshMsg.IP[k][4]);
        //   Memo.Lines.Add(inttostr(RefreshMsg.IP[k][1]) + ' - ' +inttostr(LastIP[id][1]) + ' k:' + inttostr(k) + ' id:' +inttostr(id));

          TScore := TScore + RefreshMsg.Kills[k];
          TDeaths := TDeaths + RefreshMsg.Deaths[k];
          AvgP := AvgP + RefreshMsg.Ping[k];
          inc(players);

          if (RefreshMsg.IP[i][1] = 0) and (RefreshMsg.IP[i][2] = 0) and
            (RefreshMsg.IP[i][3] = 0) and (RefreshMsg.IP[i][4] = 0) then
            inc(bots);
          if (RefreshMsg.Team[i] = 5) then
            inc(specs);

        end; // if team < 6
      end;
    end;

  end //if playerlist items = 0
  else
  begin

    // refresh players or add new players to the list
//     for i:= 1 to 5 do P_Teams[i]:=0;
    for i := 1 to MAX_PLAYERS do
    begin
      if (ServerList[ServerTab.TabIndex].RefreshMsg.Team[i] < 6) then
        inc(P_Teams[ServerList[ServerTab.TabIndex].RefreshMsg.Team[i]]);
      for j := 0 to PlayerList.Items.Count - 1 do
      begin
        if (ServerList[ServerTab.TabIndex].RefreshMsg.Team[i] < 6) then
        begin

          if (PlayerList.Items[j].Caption =
            inttostr(ServerList[ServerTab.TabIndex].RefreshMsg.Number[i])) and
            (PlayerList.Items[j].SubItems[0] =
            ServerList[ServerTab.TabIndex].RefreshMsg.Name[i]) then
          begin
            //          ListItem:=PlayerList.Items[j];
            k := i;
            h := j;
            newplayer := false;

            ///////////////// Player Data Refresh From Here /////////////////////////
            begin
              if ServerList[ServerTab.TabIndex].RefreshMsgVers = REFRESHX_270 then
              begin
                PlayerList.Items[h].SubItems[ITEM_HWID] :=
                  ServerList[ServerTab.TabIndex].RefreshMsg.HWID[k];
              end
              else
              begin
                PlayerList.Items[h].SubItems[ITEM_HWID] := '';
              end;

              PlayerList.Items[h].SubItems[ITEM_KILLS] :=
                inttostr(ServerList[ServerTab.TabIndex].RefreshMsg.Kills[k]);

              if ServerList[ServerTab.TabIndex].RefreshMsgVers = REFRESHX_265 then
              begin
                PlayerList.Items[h].SubItems[ITEM_CAPS] :=
                  inttostr(ServerList[ServerTab.TabIndex].RefreshMsg.Caps[k]);
              end
              else
              begin
                PlayerList.Items[h].SubItems[ITEM_CAPS] := '0';
              end;
              PlayerList.Items[h].SubItems[ITEM_DEATHS] :=
                inttostr(ServerList[ServerTab.TabIndex].RefreshMsg.Deaths[k]);
            end;
            if ServerList[ServerTab.TabIndex].RefreshMsg.Team[k] < 5 then
            begin
              TScore := TScore +
                ServerList[ServerTab.TabIndex].RefreshMsg.Kills[k];
              TDeaths := TDeaths +
                ServerList[ServerTab.TabIndex].RefreshMsg.Deaths[k];
              AvgP := AvgP + ServerList[ServerTab.TabIndex].RefreshMsg.Ping[k];
              inc(players);
              // inc(ServerList[ServerTab.TabIndex].players);

              // because '0.0.0.0' gets replaced by 'Bot'
              if (PlayerList.Items[h].SubItems[ITEM_IP] = 'Bot') then
                inc(ServerList[ServerTab.TabIndex].bots);
            end;
            if ServerList[ServerTab.TabIndex].RefreshMsg.Team[k] = TEAM_SPECTATOR then
            begin
              PlayerList.Items[h].SubItems[ITEM_TEAM] := 'none';
            end
            else
            begin
              if ServerList[ServerTab.TabIndex].RefreshMsg.Deaths[k] <> 0 then
                kd := ServerList[ServerTab.TabIndex].RefreshMsg.Kills[k] /
                  ServerList[ServerTab.TabIndex].RefreshMsg.Deaths[k]
              else
                kd := 0;
              PlayerList.Items[h].SubItems[ITEM_RATIO] := formatfloat('0.00', kd);
            end;
            PlayerList.Items[h].SubItems[ITEM_PING] :=
              inttostr(ServerList[ServerTab.TabIndex].RefreshMsg.Ping[k]);
            case ServerList[ServerTab.TabIndex].RefreshMsg.Team[k] of
              0: PlayerList.Items[h].SubItems[ITEM_TEAM] := 'None';
              1: PlayerList.Items[h].SubItems[ITEM_TEAM] := 'Alpha';
              2: PlayerList.Items[h].SubItems[ITEM_TEAM] := 'Bravo';
              3: PlayerList.Items[h].SubItems[ITEM_TEAM] := 'Charlie';
              4: PlayerList.Items[h].SubItems[ITEM_TEAM] := 'Delta';
              5: PlayerList.Items[h].SubItems[ITEM_TEAM] := 'Spectator';
            else
              PlayerList.Items[h].SubItems[ITEM_TEAM] :=
                inttostr(ServerList[ServerTab.TabIndex].RefreshMsg.Team[k]);
            end; //case team of

            //////////////////sort the player list by Score descending

            if Config.sortrefresh then
            begin
              //SortDirection:= -1;  // we dont want to reset it
              //ColumnToSort:= 2;    // since customsort should work
              PlayerList.AlphaSort;
            end;
            ///////////////// Player Data Refreshed /////////////////////////
            break;
          end //if playerlist number = refresh number
          else
            newplayer := true;
        end; // if team < 6
      end;

      if not newplayer then
      begin

      end // if not new player
      else if newplayer then
      begin
        k := i;
        AddPlayersToList(k);
        //player joins while tab is active so we need to update
        id := ServerList[ServerTab.TabIndex].RefreshMsg.Number[k];
        ServerList[ServerTab.TabIndex].playerFlag[id] := DBFile.GetFlagId(
          ServerList[ServerTab.TabIndex].RefreshMsg.IP[k][1],
          ServerList[ServerTab.TabIndex].RefreshMsg.IP[k][2],
          ServerList[ServerTab.TabIndex].RefreshMsg.IP[k][3],
          ServerList[ServerTab.TabIndex].RefreshMsg.IP[k][4]);
        newplayer := false;
      end; // if new player
    end; //for i = 1 to MAX_PLAYERS - refresh msg

    //Remove players from list who are not in game

    h := PlayerList.Items.Count;
    i := 0;
    while i < h do
    begin
      found := false;

      for j := 1 to MAX_PLAYERS do
        if ServerList[ServerTab.TabIndex].RefreshMsg.Team[j] <= TEAMS_COUNT then
          if (PlayerList.Items[i].Caption =
            inttostr(ServerList[ServerTab.TabIndex].RefreshMsg.Number[j])) and
            (PlayerList.Items[i].SubItems[ITEM_NAME] =
            ServerList[ServerTab.TabIndex].RefreshMsg.Name[j]) then
          begin
            found := true;
            inc(i);
            break;
          end;

      if not found then
      begin
        PlayerList.Items[i].Delete;
        dec(h);
        if i = PlayerList.Items.Count then
          break;
      end;
    end;
    //}

  end; // if playerlist items > 0

  ////////// Show Stats data: Ping, Score, Deaths

//       players;
  if players = 0 then
    players := 1;
  AvgPing.Caption := formatfloat('0.00', AvgP / players) + ' ms';
  TotalScore.Caption := formatfloat('0.00', TScore / players) + '/' +
    formatfloat('0', TScore);
  TotalDeaths.Caption := formatfloat('0.00', TDeaths / players) + '/' +
    formatfloat('0', TDeaths);

  //Refresh the rest of this shit

  MapName.Caption := ServerList[ServerTab.TabIndex].RefreshMsg.MapName;

  j := 0;
  h := 0;

  for i := 1 to 4 do
  begin
    j := j + ServerList[ServerTab.TabIndex].RefreshMsg.TeamScore[i];
    h := h + P_Teams[i];

    TeamList.Items[i - 1].SubItems[0] :=
      inttostr(ServerList[ServerTab.TabIndex].RefreshMsg.TeamScore[i]);
    TeamList.Items[i - 1].SubItems[1] := inttostr(P_Teams[i]);
  end;

  TeamList.Items[4].SubItems[0] := '-';
  TeamList.Items[4].SubItems[1] := inttostr(P_Teams[5]);

  TeamList.Items[5].SubItems[0] := inttostr(j);
  TeamList.Items[5].SubItems[1] := inttostr(h + P_Teams[5]);

  {
        TeamList.Items[0].SubItems[0] := inttostr(ServerList[ServerTab.TabIndex].RefreshMsg.TeamScore[1]);
        TeamList.Items[1].SubItems[0] := inttostr(ServerList[ServerTab.TabIndex].RefreshMsg.TeamScore[2]);
        TeamList.Items[2].SubItems[0] := inttostr(ServerList[ServerTab.TabIndex].RefreshMsg.TeamScore[3]);
        TeamList.Items[3].SubItems[0] := inttostr(ServerList[ServerTab.TabIndex].RefreshMsg.TeamScore[4]);
  }

  perc := ServerList[ServerTab.TabIndex].RefreshMsg.TimeLimit div 3600;
  masodperc := (ServerList[ServerTab.TabIndex].RefreshMsg.TimeLimit - (perc * 3600))
    div 60;
  //Label5.Caption:= inttostr(RefreshMsg.TimeLimit);

  Time.Caption := Format('%.2d:%.2d', [perc, masodperc]);
  RefreshTime();

  PlayerCount.Caption := inttostr(PlayerList.Items.Count) + '/' +
    ServerList[ServerTab.TabIndex].Maxplayers;
  botsCount.Caption := inttostr(ServerList[ServerTab.TabIndex].bots);
  SpectCount.Caption := inttostr(ServerList[ServerTab.TabIndex].specs);
  Limit.Caption :=
    inttostr(ServerList[ServerTab.TabIndex].RefreshMsg.KillLimit);
  Bonus.Caption := ServerList[ServerTab.TabIndex].bonus;
  FF.Caption := ServerList[ServerTab.TabIndex].ff;
  Voting.Caption := inttostr(ServerList[ServerTab.TabIndex].voting);
  Respawn.Caption := ServerList[ServerTab.TabIndex].respawn;
  case ServerList[ServerTab.TabIndex].RefreshMsg.GameStyle of
    0:
      begin
        GameMode.Caption := 'Deathmatch';
        teammode := 0;
      end;
    1:
      begin
        GameMode.Caption := 'Pointmatch';
        teammode := 0;
      end;
    2:
      begin
        GameMode.Caption := 'Teammatch';
        teammode := 4;
      end;
    3:
      begin
        GameMode.Caption := 'Capture the Flag';
        teammode := 4;
      end;
    4:
      begin
        GameMode.Caption := 'Rambomatch';
        teammode := 0;
      end;
    5:
      begin
        GameMode.Caption := 'Infiltration';
        teammode := 4;
      end;
    6:
      begin
        GameMode.Caption := 'Hold the Flag';
        teammode := 4;
      end;
  else
    teammode := 0;
  end;
  //Memo.Lines.Add('Server state refreshed');
  if teammode > 0 then
  begin
    PlayerPopup.Items.Items[3].Visible := true;
    for j := 0 to teammode - 1 do
      PlayerPopup.Items.Items[3].Items[j].Visible := true;
    //PlayerList.Columns[6].Width:=65
  end
  else
  begin
    for j := 0 to 3 do
      PlayerPopup.Items.Items[3].Items[j].Visible := false;
    //PlayerList.Columns[6].Width:=0;
  end;

end;

procedure TForm1.Panel1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    SetCaptureControl(PlayerList);
    Capturing := True;
    //MouseDownPos.Y := Panel1.Top; //PlayerList.Height+PlayerList.Top;
  end;

end;

procedure TForm1.Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if Capturing then
  begin
    if Y < PlayerList.Constraints.MinHeight then
    begin
      Y := PlayerList.Constraints.MinHeight;
    end;

    //Help.Caption:= 'Y: ' + inttostr(Y);

    if (Y + PlayerList.Top) >= (Form1.Height - 75 - 30 -
      ServerList[ServerTab.TabIndex].Memo.Constraints.MinHeight) then
      Y := ServerList[ServerTab.TabIndex].Memo.Top - 7 - PlayerList.Top;

    PlayerList.Height := Y;

    ServerList[ServerTab.TabIndex].Memo.Top := Y + PlayerList.Top + 7;
    Panel1.Top := Y + PlayerList.Top;
    ServerList[ServerTab.TabIndex].Memo.Height := Form1.ClientHeight -
      PageControl.Top - ServerList[ServerTab.TabIndex].Memo.Top
      - 43; //Form1.Height - ServerList[ServerTab.TabIndex].Memo.Top -68 -31;
  end;
end;

procedure TForm1.Panel1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Capturing then
  begin
    SetCaptureControl(nil);
    Capturing := False;
    //    FormResize(Form1);
  end;
  //  Screen.Cursor:= crDefault;
end;

procedure TForm1.MemoChange(Sender: TObject);
begin
  // Cmd.Text := inttostr((Sender as TRichEdit).Lines.Count * 13) + ' ' + inttostr((Sender as TRichEdit).Height);
  // make sure the scrollbar stays at bottom when memotext gets bigger then height
  if ((Sender as TRichEdit).Lines.Count * (Sender as TRichEdit).SelAttributes.Height) < (Sender as TRichEdit).Height
    then
    (Sender as TRichEdit).Perform(WM_VSCROLL, SB_BOTTOM, 0);
end;

procedure TForm1.ServerTabChange(Sender: TObject);
var
  i: integer;
  // FoundAt, pos: longint;
  // Msg: string;
begin
  if ServerList[ServerTab.TabIndex].AutoRetry then
    AutoRetry.Checked := true
  else
    AutoRetry.Checked := false;

  ServerList[ServerTab.TabIndex].Memo.Top := Memo.Top;
  ServerList[ServerTab.TabIndex].Memo.Height := Memo.Height;
  ServerList[ServerTab.TabIndex].Memo.Width := Memo.Width;

  ServerList[ServerTab.TabIndex].Memo.Visible := true;

  PlayerList.Clear;
  Host.Text := ServerList[ServerTab.TabIndex].Client.Host;
  Port.Text := IntToStr(ServerList[ServerTab.TabIndex].Client.Port);
  Pass.Text := ServerList[ServerTab.TabIndex].Pass;

  if ServerList[ServerTab.TabIndex].AutoConnect then
    AutoConnect.Checked := true
  else
    AutoConnect.Checked := false;

  if ServerList[ServerTab.TabIndex].Client.Connected then
  begin
    EnableButtons(true);
    EnableConnectButtons(false);
    Connect.Caption := 'Disconnect';
    DoRefresh;
  end
  else
  begin
    EnableButtons(false);
    EnableConnectButtons(true);
    //  PlayerList.Clear; //:= TListView.Create(Form1);
    Connect.Caption := 'Connect';

    MapName.Caption := '';
    GameMode.Caption := '';
    Limit.Caption := '';
    Time.Caption := '';
    TimeLeft.Caption := '';
    PlayerCount.Caption := '';

    botsCount.Caption := '';
    SpectCount.Caption := '';
    Respawn.Caption := '';
    FF.Caption := '';
    Bonus.Caption := '';
    Voting.Caption := '';

    for i := 1 to 6 do
    begin
      TeamList.Items[i - 1].SubItems[0] := '';
      TeamList.Items[i - 1].SubItems[1] := '';
    end;
    AvgPing.Caption := '?';
    TotalScore.Caption := '?';
    TotalDeaths.Caption := '?';

  end;

end;

procedure TForm1.ServerTabChanging(Sender: TObject;
  var AllowChange: Boolean);
var
  serverport: Integer;
begin
  //  SetFocusToCmd(Form1);

  ServerList[ServerTab.TabIndex].Client.Host := Host.Text;
  if not (TryStrToInt(Port.Text, serverport)) then
    serverport := 0;
  ServerList[ServerTab.TabIndex].Client.Port := serverport;
  //strtoint(Port.Text);
  ServerList[ServerTab.TabIndex].Pass := Pass.Text;
  ServerList[ServerTab.TabIndex].Memo.Visible := false;

  Memo.Top := ServerList[ServerTab.TabIndex].Memo.Top;
  Memo.Height := ServerList[ServerTab.TabIndex].Memo.Height;
  Memo.Width := ServerList[ServerTab.TabIndex].Memo.Width;

  if ServerName.Visible then
    ServerName.Visible := false;

  AllowChange := true;
end;

procedure TForm1.AddServerClick(Sender: TObject);
var
  i: shortint;
begin
  i := ServerTab.Tabs.Count;
  ServerTab.Tabs.Add('Server' + inttostr(i + 1));

  ServerList[i].Config.AutoMessageList := TStringList.Create;
  ServerList[i].Config.EventFile := TStringList.Create;
  ServerList[i].Config.Events := TStringList.Create;

  ServerList[i].ServerName := 'Server' + inttostr(i + 1);
  ServerList[i].Config.Events.Add('OnLoad');
  ServerList[i].Config.EventFile.Add('');
  ServerList[i].Config.Events.Add('OnExit');
  ServerList[i].Config.EventFile.Add('');
  ServerList[i].Config.Events.Add('OnConnect');
  ServerList[i].Config.EventFile.Add('');
  ServerList[i].Config.Events.Add('OnDisconnect');
  ServerList[i].Config.EventFile.Add('');
  ServerList[i].Config.Events.Add('OnJoinRequest');
  ServerList[i].Config.EventFile.Add('');
  ServerList[i].Config.Events.Add('OnPlayerJoin');
  ServerList[i].Config.EventFile.Add('');
  ServerList[i].Config.Events.Add('OnPlayerLeave');
  ServerList[i].Config.EventFile.Add('');
  ServerList[i].Config.Events.Add('OnPlayerSpeak');
  ServerList[i].Config.EventFile.Add('');
  ServerList[i].Config.Events.Add('OnAdminConnect');
  ServerList[i].Config.EventFile.Add('');
  ServerList[i].Config.Events.Add('OnAdminDisconnect');
  ServerList[i].Config.EventFile.Add('');
  ServerList[i].Config.Events.Add('OnTimeLeft');
  ServerList[i].Config.EventFile.Add('');
  ServerList[i].Config.Events.Add('OnData');
  ServerList[i].Config.EventFile.Add('');
  ServerList[i].Config.Events.Add('OnRefresh');
  ServerList[i].Config.EventFile.Add('');
  {
    ServerList[i].Config.Events.Add('OnIRCMessage');
    ServerList[i].Config.EventFile.Add('');
    ServerList[i].Config.Events.Add('OnIRCJoin');
    ServerList[i].Config.EventFile.Add('');
    ServerList[i].Config.Events.Add('OnIRCPart');
    ServerList[i].Config.EventFile.Add('');
    ServerList[i].Config.Events.Add('OnIRCConnect');
    ServerList[i].Config.EventFile.Add('');
    ServerList[i].Config.Events.Add('OnIRCDisconnect');
    ServerList[i].Config.EventFile.Add('');
  }

  ServerList[i].AutoRetryTimer := TTimer.Create(Form1);
  ServerList[i].AutoRetryTimer.OnTimer := AutoRetryTimer;
  ServerList[i].AutoRetryTimer.Enabled := false;
  ServerList[i].AutoRetryTimer.Interval := 10000;

  ServerList[i].TimerName := TStringList.Create;

  ServerList[i].AutoSay := TTimer.Create(Form1);
  ServerList[i].AutoSay.OnTimer := AutoSayTimer;
  ServerList[i].AutoSay.Enabled := false;
  ServerList[i].AutoSay.Interval := 60000;

  ServerList[i].SwapTimer := TTimer.Create(Form1);
  ServerList[i].SwapTimer.OnTimer := SwapTimerTimer;
  ServerList[i].SwapTimer.Enabled := false;
  ServerList[i].SwapTimer.Interval := 5500;

  ServerList[i].Client := TIdTCPClient.Create(Form1);
  ServerList[i].Client.Port := 23073;

  ServerList[i].Memo := TRichEdit.Create(ServerConsole);
  ServerList[i].Memo.Parent := ServerConsole;
  ServerList[i].Memo.TabOrder := 100;
  ServerList[i].Memo.TabStop := false;
  ServerList[i].Memo.Width := Memo.Width;
  ServerList[i].Memo.Height := Memo.Height;
  ServerList[i].Memo.Left := Memo.Left;
  ServerList[i].Memo.Top := Memo.Top;
  ServerList[i].Memo.Visible := false;
  ServerList[i].Memo.Color := Config.ColorMain; // Memo.Color;
  ServerList[i].Memo.ReadOnly := true;
  ServerList[i].Memo.Font := Memo.Font;
  ServerList[i].Memo.Font.Color := Config.ColorText;
  ServerList[i].Memo.ScrollBars := ssVertical;
  ServerList[i].Memo.Constraints := Memo.Constraints;
  ServerList[i].Memo.OnChange := MemoChange;
  // ServerList[i].Memo.OnKeyDown:= MemoKeyDown;
  ServerList[i].Memo.OnKeyPress := HotKeyPress;
  ServerList[i].Memo.OnMouseUp := MemoMouseUp;
  ServerList[i].Memo.OnMouseDown := MemoMouseDown;
  // ServerList[i].Memo.OnEnter:= MemoEnter;
  // ServerList[i].Memo.OnExit:= MemoExit;
  // ServerList[i].Memo.OnMouseWheel:= MemoMouseWheel;

  ServerList[i].Client.OnConnected := ClientConnected;
  ServerList[i].Client.OnDisconnected := ClientDisconnected;
  ServerList[i].Config.balancediff := 2;
  ServerList[i].Config.savepass := true;
  ServerList[i].Config.savelog := true;
  ServerList[i].Config.hideRegistered := true;
  ServerList[i].joinedPlayerNicks := TStringList.Create;

  if (Form1.Visible) and (not Ctrl) then
  begin
    ServerTab.TabIndex := ServerTab.Tabs.Count - 1; //1;
    ClickedTab := ServerTab.TabIndex;
    ServerTabChange(nil);
  end;
  SetFocusToCmd(Form1);
end;

procedure TForm1.RemoveTimer(ServerIndex, TimerIndex: integer);
var
  i: integer;
  TempTimer: TARSSETimer;
begin
  with ServerList[ServerIndex] do
  begin
    if TimerName.Count - 1 < TimerIndex then
      exit;

    TempTimer := Timers[TimerIndex];

    for i := TimerIndex to TimerName.Count - 2 do
    begin
      Timers[i] := Timers[i + 1];
    end;

    TempTimer.Timer.Free;
    Timers[TimerName.Count - 1] := TempTimer;
    TimerName.Delete(TimerName.Count - 1);

  end;
end;

function DelTree(DirName: string): Boolean;
var
  SHFileOpStruct: TSHFileOpStruct;
  DirBuf: array[0..255] of char;
begin
  try
    Fillchar(SHFileOpStruct, Sizeof(SHFileOpStruct), 0);
    FillChar(DirBuf, Sizeof(DirBuf), 0);
    StrPCopy(DirBuf, DirName);
    with SHFileOpStruct do
    begin
      Wnd := 0;
      pFrom := @DirBuf;
      wFunc := FO_DELETE;
      fFlags := FOF_ALLOWUNDO;
      fFlags := fFlags or FOF_NOCONFIRMATION;
      fFlags := fFlags or FOF_SILENT;
    end;
    Result := (SHFileOperation(SHFileOpStruct) = 0);
  except
    Result := False;
  end;
end;

procedure TForm1.RemoveServerClick(Sender: TObject);
var
  i, tabindex: integer;
begin
  if ServerTab.Tabs.Count = 1 then
    exit;

  tabindex := ClickedTab;

  // ShowMessage(inttostr(tabindex));

  if (tabindex > ServerTab.Tabs.Count - 1) then
    tabindex := ServerTab.Tabs.Count - 1;
  if (tabindex = -1) then
    tabindex := ServerTab.TabIndex;

  // ShowMessage(inttostr(tabindex));

  if ServerList[tabindex].Client.Connected then
  begin
    if MessageDlg('You are still connected. Close this tab anyway?',
      mtConfirmation, [mbYes, mbNo], 0) = mrNo then
      exit
    else
      ServerList[tabindex].Client.Disconnect;
    WriteToLog('Session Close: ' + FormatDateTime('ddd mmm dd hh:mm:ss yyyy',
      now), tabindex);
    WriteToLog('', tabindex);
  end;

  if (DirectoryExists(ExtractFilePath(Application.ExeName) + 'logs\' +
    ServerList[tabindex].ServerName + '.log')) then
    if MessageDlg('Do you want to remove the logiles for this server too?',
      mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      if DelTree(ExtractFilePath(Application.ExeName) + 'logs\' +
        ServerList[tabindex].ServerName + '.log') = false then
        ShowMessage('Couldn''t remove logfiles!');
    end;

  if tabindex = ServerTab.TabIndex then
  begin
    if tabindex > 0 then
      ServerTab.TabIndex := tabindex - 1
    else
      ServerTab.TabIndex := 1;
    ServerTabChange(nil);
  end;

  ServerTab.Tabs.Delete(tabindex);
  ServerList[tabindex].Memo.Visible := false;

  ClickedTab := ServerTab.TabIndex;

  for i := tabindex to ServerTab.Tabs.Count do
  begin
    ServerList[i] := ServerList[i + 1];
  end;

  ServerList[ServerTab.Tabs.Count].Client.Free;
  ServerList[ServerTab.Tabs.Count].Memo.Free;
  ServerList[tabindex].joinedPlayerNicks.Free;

  FormResize(Form1);

  SetFocusToCmd(Form1);

end;

procedure TForm1.MemoMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Clipboard.SetTextBuf(PChar((Sender as TRichEdit).SelText));

  //  (Sender as TRichEdit).SelLength:=0;
  //  HideCaret((Sender as TRichEdit).Handle); //lets allow them to be visible since it works now somehow
  //  if Button = mbRight then ServerList[ServerTab.TabIndex].AutoScroll:=true;
  with(Sender as TRichEdit) do
  begin
     HideSelection := true;
  end;
  ServerList[ServerTab.TabIndex].stopparse := false;

  if (Sender as TRichEdit).SelLength <= 0 then
  begin
    SetFocusToCmd(Sender);
    if Cmd.Enabled then
      Cmd.SetFocus
    else
      PlayerList.SetFocus;
  end;
  // if Cmd.Enabled then Cmd.SetFocus else Panel1.SetFocus;
  // Memo.Enabled:=false;
end;

procedure TForm1.AddFavServMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
    FavoritesPopup.Popup(Form1.Left + AddFavServ.Left + 25, Form1.Top +
      AddFavServ.Top + AddFavServ.Height + GroupBox2.Top +
      AddFavServ.Height + 28);

  //Label5.Caption:= 'Y: ' + inttostr(Form1.Top + AddFavServ.Top + AddFavServ.Height);
  if Cmd.Enabled then
    Cmd.SetFocus
  else
    Panel1.SetFocus;
end;

procedure TForm1.ServerTabMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ClickedTab := ServerTab.IndexOfTabAt(X, Y);
  if (Button = mbLeft) or (Button = mbMiddle) then
    TabClicked := true
  else
    TabClicked := false; //Screen.Cursor:= crDrag;
  //Memo.Lines.SaveToStream(ServerList[ServerTab.TabIndex].MemoStream);
  if ssDouble in Shift then
    Form1.Rename1Click(ServerTab);
end;

procedure TForm1.Rename1Click(Sender: TObject);
var
  TabRect: TRect;
begin
  TabRect := ServerTab.TabRect(ClickedTab);
  ServerName.Top := TabRect.Top + 2;
  ServerName.Left := TabRect.Left + 2;
  ServerName.Width := TabRect.Right - TabRect.Left - 4;
  ServerName.Height := TabRect.Bottom - TabRect.Top - 2;
  // ServerName.Text:= ServerTab.Tabs[ClickedTab];
  ServerName.Text := ServerList[ClickedTab].ServerName;
  ServerName.Visible := true;
  ServerName.SetFocus;
end;

procedure TForm1.ServerNameExit(Sender: TObject);
begin
  ServerName.Visible := false;
  if ServerName.Text <> '' then
  begin
    ServerTab.Tabs[ClickedTab] := ServerName.Text;
    ServerList[ClickedTab].ServerName := ServerName.Text;
    ServerName.Visible := false;
  end;
end;

procedure TForm1.ServerNameKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    ServerName.Text := '';
    ServerName.Visible := false;
    exit;
  end;
  if Key = #13 then
    ServerNameExit(Sender);
  {
    if ServerName.Text <> '' then
    begin
     ServerTab.Tabs[ClickedTab]:= ServerName.Text;
     ServerName.Visible:= false;
    end;
  }
end;

procedure TForm1.UpdateData1Click(Sender: TObject);
var
  i: integer;
  conf: TStringlist;
  sections: TStringlist;
  ini: Tinifile;
  found: boolean;
begin
  found := false;
  conf := Tstringlist.create;
  sections := Tstringlist.create;
  ini := Tinifile.Create(ExtractFilePath(Application.ExeName) +
    'fav_servers.ini');

  ini.ReadSections(sections);

  for i := 0 to sections.Count - 1 do
  begin
    ini.ReadSectionValues(sections[i], conf);
    if (conf.Values['Host'] = Host.Text) and (conf.Values['Port'] = Port.Text)
      then
    begin
      //   ini.WriteString(sections[i], 'Name', ServerTab.Tabs[ServerTab.Tabindex]);
      ini.WriteString(sections[i], 'Name',
        ServerList[ServerTab.Tabindex].ServerName);
      ini.WriteString(sections[i], 'Host', Host.Text);
      ini.WriteString(sections[i], 'Port', Port.Text);
      ini.WriteString(sections[i], 'Pass', idEncoderUUE1.Encode(Pass.Text));

      //  Fav_Serv.Name[i]:= ServerTab.Tabs[ServerTab.Tabindex];
      Fav_Serv.Name[i] := ServerList[ServerTab.Tabindex].ServerName;
      Fav_Serv.Host[i] := Host.Text;
      Fav_Serv.Port[i] := Port.Text;
      Fav_Serv.Pass[i] := Pass.Text;

      found := true;
      MessageDlg('Server information updated.', mtInformation, [mbOk], 0);
      break;
    end
    else
      found := false;

  end;

  if not found then
  begin
    MessageDlg('Server not in favourite server list.', mtError, [mbOk], 0);

  end;

  ini.free;
  conf.Free;
  sections.Free;

end;

procedure TForm1.DeleteServer1Click(Sender: TObject);
var
  i: integer;
  conf: TStringlist;
  sections: TStringlist;
  ini: Tinifile;
  found: boolean;
  Oldhost: string;
begin
  found := false;
  conf := Tstringlist.create;
  sections := Tstringlist.create;
  ini := Tinifile.Create(ExtractFilePath(Application.ExeName) +
    'fav_servers.ini');

  ini.ReadSections(sections);

  for i := 0 to sections.Count - 1 do
  begin
    ini.ReadSectionValues(sections[i], conf);
    if (conf.Values['Host'] = Host.Text) and (conf.Values['Port'] = Port.Text)
      then
    begin
      found := true;
      
      if MessageDlg('Remove server from favourites?', mtConfirmation, [mbNo,
        mbYes], 0) = mrYes then
      begin
        ini.EraseSection(sections[i]);

        Oldhost := Host.Text;
        Fav_Serv.Name.Delete(i);
        Fav_Serv.Host.Delete(i);
        Fav_Serv.Port.Delete(i);
        Fav_Serv.Pass.Delete(i);
        Host.Items.Delete(i);

        Host.Text := Oldhost;
        MessageDlg('Server removed from favourites.', mtInformation, [mbOk], 0);
        break;
      end
    end
    else
      found := false;

  end;

  if not found then
  begin
    MessageDlg('Server not in favourite server list.', mtError, [mbOk], 0);

  end;

  ini.free;
  conf.Free;
  sections.Free;

end;

procedure TForm1.LoadScript(script: string; index: integer);
var
  f: textfile;
  Cmd: string;
begin
  if not fileexists(ExtractFilePath(Application.ExeName) + 'script\' + script + '.txt') then
  begin
    MemoAppend(index, ServerList[index].Memo.Font.Color, 'Error: script file "' + script + '" not found');
    //ServerList[index].Memo.Lines.Append{bb}('Error: script file "' + script + '" not found');
  //  MemoAdd(ServerList[index].Memo,'Error: script file "' + script + '" not found');
    exit;
  end;

  AssignFile(F, ExtractFilePath(Application.ExeName) + 'script\' + script + '.txt');
  Reset(F);
  try
    try
      while not EOF(F) do
      begin
        Readln(F, Cmd);
        ServerList[index].Client.WriteLn(Cmd);
      end;
    except
    end;
  finally
    CloseFile(F);
  end;

end;

procedure TForm1.IRCConnectClick(Sender: TObject);
begin
  if not IRC.Connected then
  begin
    IRC.Host := Config.IRC.Server;
    IRC.Port := Config.IRC.Port;
    IRC.Nick := Config.IRC.Nick;
    IRC.AltNick := Config.IRC.AltNick;
    IRC.Username := Config.IRC.Username;
    IRC.RealName := 'ARSSE Bot';
    ServerList[ServerTab.TabIndex].Client.Port := strtoint(Port.Text);
    IRCConsole.Lines.Add('(' + FormatDateTime('HH:mm:ss', now) +
      ') * Connecting to ' + Config.IRC.Server + ':' +
      inttostr(Config.IRC.Port));
    IRCConnect.Caption := 'Disconnect';
    try
      IRC.Connect;
    except
      IRCConsole.Lines.Add('(' + FormatDateTime('HH:mm:ss', now) +
        ') * Connection failed.');
      IRCConnect.Caption := 'Connect';
    end;
  end
  else if IRC.Connected then
  begin
    IRCConnect.Caption := 'Connect';
    try
      IRC.WriteLn('QUIT :Enough fun for me today.');
      IRC.Disconnect(false); //.Disconnect;
    except
    end;

  end;
end;

procedure TForm1.IRCReceive(Sender: TObject; ACommand: string);
var
  // seged , params, values,
  name, msg, ident, host, channel: string;
  params, values: TStringList;
  i: integer;
begin
  if not IRC.Connected then
    exit;

  // IRCConsole.Lines.Add(ACommand);

   //////// On IRC Message ///////

  if Matches(':*!*@* PRIVMSG * :*', ACommand) then
  begin
    name := Copy(ACommand, 2, Pos('!', ACommand) - 2);
    ident := Copy(ACommand, Pos('!', ACommand) + 1, Pos('@', ACommand) -
      Pos('!', ACommand) - 1);
    host := Copy(ACommand, Pos('@', ACommand) + 1, Pos(' PRIVMSG', ACommand) -
      Pos('@', ACommand) - 1);
    channel := Copy(ACommand, Pos('PRIVMSG ', ACommand) + Length('PRIVMSG '),
      Pos(' :', ACommand) - Pos('PRIVMSG ', ACommand) -
      Length('PRIVMSG '));
    msg := Copy(ACommand, Pos(' :', ACommand) + 2, Length(ACommand));

    IRCConsole.Lines.Add('(' + FormatDateTime('HH:mm:ss', now) + ') ' + '<' +
      name + '> ' + msg);

    params := TStringList.Create;
    values := TStringList.Create;

    values.Delimiter := ' ';

    values.DelimitedText := msg;
    for i := 0 to values.Count - 1 do
      params.Add('$$' + inttostr(i + 1));

    params.Delimiter := '';
    values.Delimiter := '';

    {
         seged:= msg+' ';
         params:= '';
         values:= '';
         i:= 1;
         while Pos(' ',seged) > 0 do
         begin
          values:= values +'' + (Copy(seged,1,Pos(' ',seged)-1));
          values:= values +'' + (seged);
          Delete(seged,1,Pos(' ',seged));
          //  dfgr
          params:= params +'' + ('$'+inttostr(i)+'$');
          params:= params +'' + ('$'+inttostr(i)+'-');
          inc(i);
         end;
    }

    if Config.EventOn[2] then
      EventOccure(params.DelimitedText +
        '$SENDER_IDENT$SENDER_NAME$SENDER_HOST$CHANNEL$MESSAGE$SENDER_IP$SENDER_PORT',
        values.DelimitedText + '' + ident + '' + name + '' + host + '' +
        channel + '' + msg + '' +
        ServerList[ServerTab.TabIndex].Client.Host + '' +
        IntToStr(ServerList[ServerTab.TabIndex].Client.Port),
        Config.EventFile[2], ServerTab.TabIndex);

    //  IRCConsole.Lines.Add('sender: '+name+' ident: '+ident+' host: '+host+' k�ldi: '+msg+' ezen kereszt�l: '+channel)
  end;
end;

procedure TForm1.IRCCmdKeyPress(Sender: TObject; var Key: Char);
var
  seged: string;
begin
  if not IRC.Connected then
    exit;

  if Key = #13 then
    try
      seged := IRCCmd.Text;
      if Matches('/*', seged) then
        Delete(seged, 1, 1)
      else
      begin
        seged := 'PRIVMSG ' + Config.IRC.Channel + ' :' + seged;
      end;
      IRC.WriteLn(seged);
      IRCCmd.Items.Add(seged);
      IRCConsole.Lines.Add('(' + FormatDateTime('HH:mm:ss', now) + ') ' + '[' +
        Config.IRC.Nick + '] ' + seged);
      IRCCmd.Text := '';
    except
    end;
end;

procedure TForm1.IRCMessage(Sender: TObject; AUser: TIdIRCUser;
  AChannel: TIdIRCChannel; Content: string);
var
  i, j, players: integer;
  seged, seged2: string;
  // allow: boolean;
begin
  IRCConsole.Lines.Add('(' + FormatDateTime('HH:mm:ss', now) + ') ' + '<' +
    AUser.Nick + '> ' + Content);
  if AChannel.Name = Config.IRC.Channel then
  begin
    ///////// IRC specific commands from here ////////////

    ////////  !help command //////////

    if Content = Config.IRC.Prefix + 'help' then
      //try
    begin
      IRCMsg(AChannel.Name, 'List of commands:');
      IRCMsg(AChannel.Name, Config.IRC.Prefix + 'help - display this message');
      IRCMsg(AChannel.Name, Config.IRC.Prefix +
        'servers - display list of available servers');
      IRCMsg(AChannel.Name, Config.IRC.Prefix +
        'players [num] - shows players on specified server');
      IRCMsg(AChannel.Name, Config.IRC.Prefix +
        'connect [num] - connect to the specified server. [num] is the number displayed in the !servers command.');
      IRCMsg(AChannel.Name, Config.IRC.Prefix +
        'disconnect [num] - disconnect from the specified server. [num] is the number displayed in the !servers command.');
      IRCMsg(AChannel.Name, Config.IRC.Prefix + 'kill - makes the bot go away');
      //except
    end;

    //////// !players command ///////////

    if Matches(Config.IRC.Prefix + 'players *', Content) then
      //try
    begin
      seged := Content;
      Delete(seged, 1, Length(Config.IRC.Prefix + 'players '));
      if not ServerList[strtoint(seged) - 1].Client.Connected then
      begin
        IRC.WriteLn('PRIVMSG ' + AChannel.Name + ' :Not connected to ' +
          ServerList[strtoint(seged) - 1].Client.Host);
        exit;
      end;

      seged2 := 'Players on ' + ServerList[strtoint(seged) - 1].Client.Host + ':'
        + inttostr(ServerList[strtoint(seged) -
        1].Client.Port) + ': ';
      players := 0;
      for i := 1 to MAX_PLAYERS do
        if ServerList[strtoint(seged) - 1].RefreshMsg.Team[i] < 6 then
        begin
          if i > 1 then
            seged2 := seged2 + ', ';
          seged2 := seged2 + ServerList[strtoint(seged) - 1].RefreshMsg.Name[i];
          inc(players);
          //IRC.WriteLn('PRIVMSG '+AChannel.Name+' :' + inttostr(ServerList[strtoint(seged)-1].RefreshMsg.Number[i]) + ': ' + ServerList[strtoint(seged)-1].RefreshMsg.Name[i] );
        end;

      if players > 0 then
      begin
        //Delete(seged2,Length(seged2)-2,2);
        IRC.WriteLn('PRIVMSG ' + AChannel.Name + ' :' + seged2);
      end
      else
        IRC.WriteLn('PRIVMSG ' + AChannel.Name + ' :No players on ' +
          ServerList[strtoint(seged) - 1].Client.Host + ':' +
          inttostr(ServerList[strtoint(seged) - 1].Client.Port));

      //except
    end;

    //////// !servers command ///////////

    if Content = Config.IRC.Prefix + 'servers' then
      //try
    begin
      IRC.WriteLn('PRIVMSG ' + AChannel.Name + ' :List of servers:');
      for i := 0 to ServerTab.Tabs.Count - 1 do
      begin
        //seged:= 'PRIVMSG '+AChannel.Name+' :' + inttostr(i+1) + ': ' + ServerTab.Tabs[i] + ' - ' + ServerList[i].Client.Host + ':' + inttostr(ServerList[i].Client.Port) + ' | state: ';
  //      seged:= inttostr(i+1) + ': ' + ServerTab.Tabs[i] + ' - ' + ServerList[i].Client.Host + ':' + inttostr(ServerList[i].Client.Port) + ' | state: ';
        seged := inttostr(i + 1) + ': ' + ServerList[i].ServerName + ' - ' +
          ServerList[i].Client.Host + ':' +
          inttostr(ServerList[i].Client.Port) + ' | state: ';
        if ServerList[i].Client.Connected then
        begin
          seged := seged + 'connected - mode: ';

          case ServerList[i].RefreshMsg.GameStyle of
            0: seged := seged + 'DM';
            1: seged := seged + 'PM';
            2: seged := seged + 'TDM';
            3: seged := seged + 'CTF';
            4: seged := seged + 'RM';
            5: seged := seged + 'INF';
            6: seged := seged + 'HTF';
          end;

          seged := seged + ' - map: ';

          seged := seged + ServerList[i].RefreshMsg.MapName;

          seged := seged + ' - players: ';

          players := 0;
          for j := 1 to MAX_PLAYERS do
            if ServerList[i].RefreshMsg.Team[j] < 6 then
              inc(players);

          seged := seged + inttostr(players) + '/' + ServerList[i].Maxplayers;
        end
        else
          seged := seged + 'disconnected';

        //IRC.WriteLn(seged);
        IRCMsg(AChannel.Name, seged);
      end;
      //except
    end;

    //////// !info command ///////////

    if Matches(Config.IRC.Prefix + 'info *', Content) then
      try
        seged := Content;
        Delete(seged, 1, Length(Config.IRC.Prefix + 'info '));
        i := strtoint(seged) - 1;

        //seged:= 'PRIVMSG '+AChannel.Name+' :' + inttostr(i+1) + ': ' + ServerTab.Tabs[i] + ' - ' + ServerList[i].Client.Host + ':' + inttostr(ServerList[i].Client.Port) + ' | state: ';
  //      seged:= inttostr(i+1) + ': ' + ServerTab.Tabs[i] + ' - ' + ServerList[i].Client.Host + ':' + inttostr(ServerList[i].Client.Port) + ' | state: ';
        seged := inttostr(i + 1) + ': ' + ServerList[i].ServerName + ' - ' +
          ServerList[i].Client.Host + ':' +
          inttostr(ServerList[i].Client.Port) + ' | state: ';
        if ServerList[i].Client.Connected then
        begin
          seged := seged + 'connected - mode: ';

          case ServerList[i].RefreshMsg.GameStyle of
            0: seged := seged + 'DM';
            1: seged := seged + 'PM';
            2: seged := seged + 'TDM';
            3: seged := seged + 'CTF';
            4: seged := seged + 'RM';
            5: seged := seged + 'INF';
            6: seged := seged + 'HTF';
          end;

          seged := seged + ' - map: ';

          seged := seged + ServerList[i].RefreshMsg.MapName;

          seged := seged + ' - players: ';

          players := 0;
          for j := 1 to MAX_PLAYERS do
            if ServerList[i].RefreshMsg.Team[j] < 6 then
              inc(players);

          seged := seged + inttostr(players) + '/' + ServerList[i].Maxplayers;
        end
        else
          seged := seged + 'disconnected';

        //IRC.WriteLn(seged);
        IRCMsg(AChannel.Name, seged);

      except
      end;

    //////// !newserver command ///////////

    if Matches(Config.IRC.Prefix + 'newserver', Content) then
      try
        AddServerClick(nil);
        IRC.WriteLn('PRIVMSG ' + AChannel.Name + ' :New server added (' +
          inttostr(ServerTab.Tabs.Count) + ')');
      except
      end;

    //////// !rename command ///////////

    if Matches(Config.IRC.Prefix + 'rename *', Content) then
      try
        seged := Content;
        Delete(seged, 1, Length(Config.IRC.Prefix + 'rename '));
        seged2 := seged;
        Delete(seged2, 1, Pos(' ', seged2));
        Delete(seged, Pos(' ', seged), Length(seged));
        //    ServerTab.Tabs[strtoint(seged)-1]:= seged2;
        ServerList[strtoint(seged) - 1].ServerName := seged2;
        IRC.WriteLn('PRIVMSG ' + AChannel.Name + ' :Server (' + seged +
          ') renamed to ' + seged2);
      except
      end;

    //////// !host command ///////////

    if Matches(Config.IRC.Prefix + 'host *', Content) then
    begin
      seged := Content;
      Delete(seged, 1, Length(Config.IRC.Prefix + 'host '));
      seged2 := seged;
      Delete(seged2, 1, Pos(' ', seged2));
      Delete(seged, Pos(' ', seged), Length(seged));
      i := strtoint(seged);
      seged := seged2;
      Delete(seged2, 1, Pos(':', seged2));
      Delete(seged, Pos(':', seged), Length(seged));
      ServerList[i - 1].Client.Host := seged;
      ServerList[i - 1].Client.Port := strtoint(seged2);
      if (i - 1) = ServerTab.TabIndex then
      begin
        Host.Text := seged;
        Port.Text := seged2;
      end;
      IRC.WriteLn('PRIVMSG ' + AChannel.Name + ' :Server (' + inttostr(i) +
        ') changed to ' + seged + ':' + seged2);
    end;

    //////// !passwd command ///////////

    if Matches(Config.IRC.Prefix + 'passwd *', Content) and (AChannel.Name <>
      Config.IRC.Channel) then
      try
        seged := Content;
        Delete(seged, 1, Length(Config.IRC.Prefix + 'passwd '));
        seged2 := seged;
        Delete(seged2, 1, Pos(' ', seged2));
        Delete(seged, Pos(' ', seged), Length(seged));
        ServerList[strtoint(seged) - 1].Pass := seged2;
        if (strtoint(seged) - 1) = ServerTab.TabIndex then
          Pass.Text := seged2;
        IRC.WriteLn('PRIVMSG ' + AUser.Nick + ' :Server (' + seged +
          ') password changed to ' + seged2);
      except
      end;

    //////// !say command ///////////

    if Matches(Config.IRC.Prefix + 'say *', Content) then
      try
        seged := Content;
        Delete(seged, 1, Length(Config.IRC.Prefix + 'say '));
        seged2 := seged;
        Delete(seged2, 1, Pos(' ', seged2));
        Delete(seged, Pos(' ', seged), Length(seged));
        //ServerTab.Tabs[strtoint(seged)-1]:= seged2;
    //    if not ServerList[strtoint(seged)-1].Client.Connected then IRCMsg(AChannel.Name,'Not connectd to ' + ServerTab.Tabs[strtoint(seged)-1]);
        if not ServerList[strtoint(seged) - 1].Client.Connected then
          IRCMsg(AChannel.Name, 'Not connectd to ' + ServerList[strtoint(seged)
            - 1].ServerName);
        //    IRC.WriteLn('PRIVMSG '+AChannel.Name+' :sent to ' + ServerTab.Tabs[strtoint(seged)-1] + ': ' + seged2 );
        IRC.WriteLn('PRIVMSG ' + AChannel.Name + ' :sent to ' +
          ServerList[strtoint(seged) - 1].ServerName + ': ' + seged2);
        ServerList[strtoint(seged) - 1].Client.WriteLn('/say ' + seged2);
      except
      end;

    //////// !kill command ///////////

    if (Content = Config.IRC.Prefix + 'kill') then
      // and Matches('*KeFear.users.quakenet.org*',AUser.Address) then
      try
        IRC.WriteLn('PRIVMSG ' + AChannel.Name +
          ' :*sigh* i must leave now.. :,( bye.');
        IRCConnectClick(nil);
      except
      end;

    //////// !connect command ///////////

    if Matches(Config.IRC.Prefix + 'connect *', Content) then
      try
        seged := Content;
        Delete(seged, 1, Length(Config.IRC.Prefix + 'connect '));
        if ServerList[strtoint(seged) - 1].Client.Connected then
        begin
          IRC.WriteLn('PRIVMSG ' + AChannel.Name + ' :' +
            ServerList[strtoint(seged) - 1].Client.Host +
            ' already connected.');
          exit;
        end;
        if (strtoint(seged) > ServerTab.Tabs.Count) or (strtoint(seged) < 1)
          then
        begin
          IRC.WriteLn('PRIVMSG ' + AChannel.Name + ' :Error: No server number '
            + seged + ' found. Please replace user.');
          exit;
        end;

        i := ServerTab.TabIndex;
        ServerTab.TabIndex := strtoint(seged) - 1;
        ServerTabChange(nil);
        ConnectClick(nil);
        ServerTab.TabIndex := i;
        ServerTabChange(nil);
      except
      end;

    //////// !disconnect command ///////////

    if Matches(Config.IRC.Prefix + 'disconnect *', Content) then
      try
        seged := Content;
        Delete(seged, 1, Length(Config.IRC.Prefix + 'disconnect '));
        if not ServerList[strtoint(seged) - 1].Client.Connected then
        begin
          IRC.WriteLn('PRIVMSG ' + AChannel.Name + ' :' +
            ServerList[strtoint(seged) - 1].Client.Host +
            ' already disconnected.');
          exit;
        end;
        if (strtoint(seged) > ServerTab.Tabs.Count) or (strtoint(seged) < 1)
          then
        begin
          IRC.WriteLn('PRIVMSG ' + AChannel.Name + ' :Error: No server number '
            + seged + ' found. Please replace user.');
          exit;
        end;

        i := ServerTab.TabIndex;
        ServerTab.TabIndex := strtoint(seged) - 1;
        ServerTabChange(nil);
        ConnectClick(nil);
        ServerTab.TabIndex := i;
        ServerTabChange(nil);
      except
      end;

    //////// End of IRC specific commands ////////////////
  end;
end;

procedure TForm1.IRCConnected(Sender: TObject);
begin
  // IRCConsole.Lines.Add('(' + FormatDateTime('HH:mm:ss',now) + ') * Connected to ' + IRCServer.Text + ':'+ IRCPort.Text);
  Settings1.IRCServer.Enabled := false;
  Settings1.IRCPort.Enabled := false;
  Settings1.IRCNick.Enabled := false;
  Settings1.IRCChannel.Enabled := false;
  Settings1.IRCKey.Enabled := false;
  Settings1.IRCAltNick.Enabled := false;
  // Settings1.prefix.Enabled:= false;
  Settings1.QNetPass.Enabled := false;
  Settings1.QNetUser.Enabled := false;
  Settings1.QNetAuth.Enabled := false;
  Settings1.QNetBot.Enabled := false;
  Settings1.QNetCmd.Enabled := false;
end;

procedure TForm1.IRCDisconnected(Sender: TObject);
begin
  IRCConsole.Lines.Add('(' + FormatDateTime('HH:mm:ss', now) +
    ') * Disconnected.');

  Settings1.IRCServer.Enabled := true;
  Settings1.IRCPort.Enabled := true;
  Settings1.IRCNick.Enabled := true;
  Settings1.IRCChannel.Enabled := true;
  Settings1.IRCKey.Enabled := true;
  Settings1.IRCAltNick.Enabled := true;
  Settings1.prefix.Enabled := true;
  Settings1.QNetPass.Enabled := true;
  Settings1.QNetUser.Enabled := true;
  Settings1.QNetAuth.Enabled := true;
  Settings1.QNetBot.Enabled := true;
  Settings1.QNetCmd.Enabled := true;
end;

procedure TForm1.IRCJoined(Sender: TObject; AChannel: TIdIRCChannel);
begin
  if not IRC.Connected then
    exit;
  IRCConsole.Lines.Add('(' + FormatDateTime('HH:mm:ss', now) +
    ') * Now talking in ' + AChannel.Name);
  try
    IRC.WriteLn('NAMES ' + AChannel.Name);
    if Config.EventOn[3] then
      EventOccure('$CHANNEL_NAME', AChannel.Name, Config.EventFile[3],
        ServerTab.TabIndex);
    //IRC.WriteLn('PRIVMSG '+AChannel.Name+' :I''m back, now all your server are belong to me.');
  except
  end;
end;

procedure TForm1.IRCJoin(Sender: TObject; AUser: TIdIRCUser;
  AChannel: TIdIRCChannel);
begin
  if not IRC.Connected then
    exit;
  IRCConsole.Lines.Add('(' + FormatDateTime('HH:mm:ss', now) + ') * ' +
    AUser.Nick + ' has joined ' + AChannel.Name);
end;

procedure TForm1.IRCError(Sender: TObject; AUser: TIdIRCUser; ANumeric,
  AError: string);
begin
  if not IRC.Connected then
    exit;
  IRCConsole.Lines.Add('(' + FormatDateTime('HH:mm:ss', now) + ') * Error: ' +
    AError);
end;

procedure TForm1.IRCSystem(Sender: TObject; AUser: TIdIRCUser;
  ACmdCode: Integer; ACommand, AContent: string);
begin
  if not IRC.Connected then
    exit;

  try
    if ACmdCode = 1 then
    begin

      //   if Matches('*quakenet*',Config.IRC.Server) and Config.IRC.auth then
      if Config.IRC.auth then
      begin
        IRC.WriteLn('PRIVMSG ' + Config.IRC.ABot + ' :' + Config.IRC.ACmd + ' '
          + Config.IRC.ANick + ' ' + Config.IRC.APass);
        IRC.WriteLn('MODE ' + Config.IRC.Nick + ' +x');
      end;

      if Config.IRC.ChanKey = '' then
        IRC.WriteLn('JOIN ' + Config.IRC.Channel)
      else
        IRC.WriteLn('JOIN ' + Config.IRC.Channel + ' ' + Config.IRC.ChanKey)

    end;
  except
  end;

end;

procedure TForm1.HostChange(Sender: TObject);
begin
  ServerList[ServerTab.TabIndex].Client.Host := Host.Text;
end;

procedure TForm1.PortChange(Sender: TObject);
var
  serverport: Integer;
begin
  if not TryStrToInt(Port.Text, serverport) then
    serverport := 0;
  ServerList[ServerTab.TabIndex].Client.Port := serverport;
end;

//END of SOURCE (are you sure KeFear?)

procedure TForm1.PassChange(Sender: TObject);
begin
  ServerList[ServerTab.TabIndex].Pass := Pass.Text;
end;

procedure TForm1.MemoMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  buffer, url: string;
  start, len: Integer;
begin
  Memo.Enabled := false;

  // HideCaret((Sender as TRichEdit).Handle);
  selbegin := (Sender as TRichEdit).SelStart;
  // autoscr:=ServerList[ServerTab.TabIndex].AutoScroll;
  ServerList[ServerTab.TabIndex].stopparse := true;
  (Sender as TRichEdit).HideSelection := false;

  // Clicking and executing commands BEGIN
  if Ctrl then
  begin
    // ShowMessage((Sender as TRichEdit).Lines[ SendMessage((Sender as TRichEdit).Handle, EM_LINEFROMCHAR , -1 ,0)]);
    buffer := (Sender as TRichEdit).Lines[SendMessage((Sender as
      TRichEdit).Handle, EM_LINEFROMCHAR, -1, 0)];
    // remove date
    if Matches('(??:??:??) *', buffer) then
      Delete(buffer, 1, 11);
    // remove IP
    if Matches('* (*.*.*.*)*', buffer) then
      buffer := Copy(buffer, 0, PosEx(' (', buffer, 0) - 1);
  
    if Matches('*http://*.*', buffer) then
    begin
      url := 'http://';
    end
    else if Matches('*https://*.*', buffer) then
    begin
      url := 'https://';
    end
    else if Matches('*soldat://*:*', buffer) then
    begin
      url := 'soldat://';
    end
    else if Matches('*irc://', buffer) then
    begin
      url := 'irc://';
    end
    // check for command
    else if Matches('/*', buffer) then
      ServerList[ServerTab.Tabindex].Client.WriteLn(buffer);
    
    if Length(url) > 0 then
    begin
      start := PosEx(url, buffer, 0);
      len := PosEx(' ', buffer, start);
      if len = 0 then
        len := Length(buffer);

      len := len - start + 1;
      ShowMessage('1: ' + url + ' 2: ' + IntToStr(start) + ' 3: ' + IntToStr(len) + ' 4: ' + buffer);
      url := Copy(buffer, start, len);
      ShowMessage(url);
      ShellExecute(0, PChar('open'),
        PChar(url), PChar(0), nil, SW_NORMAL);
    end;
  end;
  // Clicking and executing commands END
end;

procedure TForm1.IRCMsg(Target, Msg: string);
begin
  try
    IRC.WriteLn('PRIVMSG ' + Target + ' :' + Msg);
    IRCConsole.Lines.Append('(' + FormatDateTime('HH:mm:ss', now) + ') ' + '[' +
      Config.IRC.Nick + '] ' + Msg);
    //  IRCConsole.Lines.Add('(' + FormatDateTime('HH:mm:ss',now) + ') ' + '[' + Config.IRC.Nick + '] ' + Msg);
    Sleep(300);
  except
  end;

end;

procedure TForm1.IRCNames(Sender: TObject; AUsers: TIdIRCUsers;
  AChannel: TIdIRCChannel);
//var i: integer;
begin
  // for i:= Low(AUsers.Items) to High(AUsers.Items) do
  //   UserBox.Items.Add(AUsers.Items[i].Nick);
  UserBox.Items := AChannel.Names;
end;

procedure TForm1.TeamListCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
var
 p: TPoint;
begin
  if Item.Caption = 'Alpha' then
    Sender.Canvas.Font.Color := clRed
  else if Item.Caption = 'Bravo' then
    Sender.Canvas.Font.Color := clBlue
  else if Item.Caption = 'Charlie' then
    Sender.Canvas.Font.Color := clOlive
  else if Item.Caption = 'Delta' then
    Sender.Canvas.Font.Color := clGreen
  else if Item.Caption = 'Spec' then
    Sender.Canvas.Font.Color := clPurple
  else
    begin
    P := TListView(Sender).Items[Item.Index-1].GetPosition;
    Sender.Canvas.Pen.Color := clGrayText;
    Sender.Canvas.MoveTo(p.X-10,p.Y);
    Sender.Canvas.LineTo(p.X+200,p.Y);
    Sender.Canvas.Font.Color := clBlack;
  end
end;

procedure TForm1.TeamListCustomDrawSubItem(Sender: TCustomListView;
  Item: TListItem; SubItem: Integer; State: TCustomDrawState;
  var DefaultDraw: Boolean);
begin
  Sender.Canvas.Font.Color := clBlack;
end;

procedure TForm1.EventOccure(param, value, scriptfile: string; index: integer);
var
  params, values: TStringList; //forlist
  f: textfile;
  // seged,
  sor: string;
  i: integer;
  // kezdo,
  // i,j, players {, forlow, forhigh, alpha, bravo}: integer;
begin
  // inif:= false;
  voltmarif := false;
  // infor:= false;
  // ifstate:= false;
  // forlow:= 0;
  // forhigh:= 0;
  //  kezdo:=0;
  params := TStringList.Create;
  values := TStringList.Create;
  //  forlist:= TStringList.Create;

  if param <> '' then
  begin
    while (Pos(' ', param) = 1) and (Length(param) > 1) do
      Delete(param, 1, 1);
    while (Pos(' ', value) = 1) and (Length(value) > 1) do
      Delete(value, 1, 1);

    // $DATA etc bugfix
    i := Pos('$', value);
    while(i <> 0) do
    begin
      value[i] := '�';
      i := Pos('$', value);
    end;

    param := param + '';
    value := value + '';

    while Pos('', param) > 0 do

    begin
      params.Add(Copy(param, 1, Pos('', param) - 1));
      Delete(param, 1, Pos('', param));

      values.Add(Copy(value, 1, Pos('', value) - 1));
      Delete(value, 1, Pos('', value));
    end;
  end;
  params.Add('$VERSION');
  params.Add('$CLOCK');
  params.Add('$SERVER_NAME');
  params.Add('$SERVER_NUM');
  params.Add('$PREFIX');
  params.Add('$BOTNICK');
  params.Add('$SERVER_COUNT');
  params.Add('$ALPHA_PLAYERS');
  params.Add('$BRAVO_PLAYERS');
  params.Add('$CHARLIE_PLAYERS');
  params.Add('$DELTA_PLAYERS');
  params.Add('$MAXPLAYERS');
  params.Add('$PLAYERS_COUNT');
  params.Add('$ALPHA_SCORE');
  params.Add('$BRAVO_SCORE');
  params.Add('$CHARLIE_SCORE');
  params.Add('$DELTA_SCORE');
  params.Add('$NEXTMAP');
  params.Add('$MAP');
  params.Add('$ADMIN_NAME');
  params.Add('$DATE');

  values.Add('ARSSE version ' + VERSION + ' (Build ' + VERSIONBUILD + ') ' +
    VERSIONSTATUS); //Label5.Caption);
  values.Add(FormatDateTime('hh:mm:ss', now));
  //  values.Add(ServerTab.Tabs[index]);
  values.Add(ServerList[index].ServerName);
  values.Add(inttostr(index + 1));
  values.Add(Config.IRC.Prefix);
  values.Add(IRC.Nick);
  values.Add(inttostr(ServerTab.Tabs.Count));
  values.Add(inttostr(ServerList[index].Teams[1]));
  values.Add(inttostr(ServerList[index].Teams[2]));
  values.Add(inttostr(ServerList[index].Teams[3]));
  values.Add(inttostr(ServerList[index].Teams[4]));
  values.Add(inttostr(ServerList[index].MaxPlayer));
  values.Add(inttostr(PlayerNum(index)));
  values.Add(inttostr(ServerList[index].RefreshMsg.TeamScore[1]));
  values.Add(inttostr(ServerList[index].RefreshMsg.TeamScore[2]));
  values.Add(inttostr(ServerList[index].RefreshMsg.TeamScore[3]));
  values.Add(inttostr(ServerList[index].RefreshMsg.TeamScore[4]));
  values.Add(ServerList[index].RefreshMsg.NextMap);
  values.Add(ServerList[index].RefreshMsg.MapName);
  values.Add(Config.AdminName);
  values.Add(FormatDateTime('yyyy-mm-dd', Date));

  // �zenett�red�kek
  {
       seged:= msg+' ';
       params:= '';
       values:= '';
       i:= 1;
       while Pos(' ',seged) > 0 do
       begin
        values:= values +'' + (Copy(seged,1,Pos(' ',seged)-1));
        values:= values +'' + (seged);
        Delete(seged,1,Pos(' ',seged));
        //  dfgr
        params:= params +'' + ('$'+inttostr(i)+'$');
        params:= params +'' + ('$'+inttostr(i)+'-');
        inc(i);
       end;
  }
       //szerverlista volt

  {  for i:= 0 to ServerTab.Tabs.Count -1 do
    begin
     params.Add('$SERVER['+inttostr(i+1)+'].NAME');
     values.Add(ServerTab.Tabs[i]);
     params.Add('$SERVER['+inttostr(i+1)+'].HOST');
     values.Add(ServerList[i].Client.Host);
     params.Add('$SERVER['+inttostr(i+1)+'].PORT');
     values.Add(inttostr(ServerList[i].Client.Port));
     params.Add('$SERVER['+inttostr(i+1)+'].CONNECT_STATE');
     if not ServerList[i].Client.Connected then
          values.Add('disconnected')
     else
     begin
      values.Add('connected');

      params.Add('$SERVER['+inttostr(i+1)+'].MAP');
      values.Add(ServerList[i].RefreshMsg.MapName);

      params.Add('$SERVER['+inttostr(i+1)+'].GAMEMODE');
      case ServerList[i].RefreshMsg.GameStyle of
       0: values.Add('DM');
       1: values.Add('PM');
       2: values.Add('TDM');
       3: values.Add('CTF');
       4: values.Add('RM');
       5: values.Add('INF');
       6: values.Add('HTF');
      end;
      params.Add('$SERVER['+inttostr(i+1)+'].KILLLIMIT');
      values.Add(inttostr(ServerList[i].RefreshMsg.KillLimit));
      players:=0;
      for j:= 1 to MAX_PLAYERS do
       if (ServerList[i].RefreshMsg.Team[j] < 6) and (ServerList[i].RefreshMsg.Number[j] > 0) then
       begin
         inc(players);
         params.Add('$SERVER['+inttostr(i+1)+'].PLAYER['+inttostr(ServerList[i].RefreshMsg.Number[j])+'].NAME');
         values.Add(ServerList[i].RefreshMsg.Name[j]);
         params.Add('$SERVER['+inttostr(i+1)+'].PLAYER['+inttostr(ServerList[i].RefreshMsg.Number[j])+'].TEAM');
         case ServerList[i].RefreshMsg.Team[j] of
          0: values.Add('None');
          1: values.Add('Alpha');
          2: values.Add('Bravo');
          3: values.Add('Charlie');
          4: values.Add('Delta');
          5: values.Add('Spectator');
         end;
         params.Add('$SERVER['+inttostr(i+1)+'].PLAYER['+inttostr(ServerList[i].RefreshMsg.Number[j])+'].NUMBER');
         values.Add(inttostr(ServerList[i].RefreshMsg.Number[j]));
         params.Add('$SERVER['+inttostr(i+1)+'].PLAYER['+inttostr(ServerList[i].RefreshMsg.Number[j])+'].KILLS');
         values.Add(inttostr(ServerList[i].RefreshMsg.Kills[j]));
         params.Add('$SERVER['+inttostr(i+1)+'].PLAYER['+inttostr(ServerList[i].RefreshMsg.Number[j])+'].DEATHS');
         values.Add(inttostr(ServerList[i].RefreshMsg.Deaths[j]));
         params.Add('$SERVER['+inttostr(i+1)+'].PLAYER['+inttostr(ServerList[i].RefreshMsg.Number[j])+'].IP');
         values.Add(inttostr(ServerList[i].RefreshMsg.IP[j][1])+'.'+inttostr(ServerList[i].RefreshMsg.IP[j][2])+'.'+inttostr(ServerList[i].RefreshMsg.IP[j][3])+'.'+inttostr(ServerList[i].RefreshMsg.IP[j][4]));
         params.Add('$SERVER['+inttostr(i+1)+'].PLAYER['+inttostr(ServerList[i].RefreshMsg.Number[j])+'].PING');
         values.Add(inttostr(ServerList[i].RefreshMsg.Ping[j]));
       end;
      params.Add('$SERVER['+inttostr(i+1)+'].PLAYERS');
      values.Add(inttostr(players));
      params.Add('$SERVER['+inttostr(i+1)+'].MAXPLAYERS');
      values.Add(ServerList[i].Maxplayers);
     end;
    end;

  // eddig volt a kikommentez�s }
  //  for i:=0 to params.Count-1 do ServerList[index].Memo.Lines.Add(params[i] + ' -> ' + values[i]);

  if not Matches('*:\*', scriptfile) then
    scriptfile := ExtractFilePath(Application.ExeName) + scriptfile;

  if fileexists(scriptfile) then
  begin
    AssignFile(f, scriptfile);
    try
      Reset(F);
      try

        while not Eof(f) do
        begin
          ReadLn(F, sor);

          if (sor <> '') and not Matches(sor, '*$*') then
          begin

            // remove spaces in front and at the end of the line
            while (Pos(' ', sor) = 1) and (Length(sor) > 1) do
              Delete(sor, 1, 1);
            while (sor[length(sor)] = ' ') and (Length(sor) > 1) do
              Delete(sor, Length(sor), 1);

            //    ServerList[index].Memo.Lines.Add(sor);
            //    ServerList[index].Memo.Lines.Add('inif: '+booltostr(inif));
            //    ServerList[index].Memo.Lines.Add('infor: '+booltostr(infor));
            //    ServerList[index].Memo.Lines.Add('ifstate: '+booltostr(ifstate));
            //    ServerList[index].Memo.Lines.Add('voltmarif: '+booltostr(voltmarif));

            // itt volt a parse r�sz.

            {    if Matches('FOR $I*',UpperCase(sor)) and not inif then // and not infor then
                 begin

                  forlist:= TStringList.Create;
                  Delete(sor,1,Length('FOR $I'));

                  while (Pos(' ',sor) = 1) and (Length(sor)>1) do Delete(sor,1,1);
                  while (sor[length(sor)] = ' ') and (Length(sor)>1) do Delete(sor,Length(sor),1);

                  if Matches(':=* to *',sor) then
                  begin
                   Delete(sor,1,2);
                   while (Pos(' ',sor) = 1) and (Length(sor)>1) do Delete(sor,1,1);

            //       forlist.Add(Copy(sor,1,Pos(' to ',sor)));
                   seged:=Copy(sor,1,Pos(' to ',sor));
                   Delete(sor,1,Pos('to',sor)+1);

                   while (Pos(' ',seged) = 1) and (Length(seged)>1) do Delete(seged,1,1);
                   while (seged[length(seged)] = ' ') and (Length(seged)>1) do Delete(seged,Length(seged),1);
                   while (Pos(' ',sor) = 1) and (Length(sor)>1) do Delete(sor,1,1);

                  for i:= params.Count-1 downto 0 do
                  if Matches('*'+params[i]+'*',sor) then
                  begin
                   sor:= AnsiReplaceStr(sor,params[i],values[i]);
                  end;

                   forlow:= strtoint(seged);
                   forhigh:= strtoint(sor);
                   params.Add('$I');
                   values.Add(inttostr(forlow));
                   infor:= true;
                   ifstate:= inif;
            //       ServerList[index].Memo.Lines.Add(inttostr(forlow));
            //       ServerList[index].Memo.Lines.Add(inttostr(forhigh));
            //
                  end;

            //      continue;
                 end;

                if Matches('ENDFOR',UpperCase(sor)) and not inif then //and infor
                 begin

                  infor:= false;
                  if forlow < forhigh then
                   for i:= forlow to forhigh do
                    for j:= 0 to forlist.Count-1 do
                    begin
                      values[values.Count-1]:= inttostr(i); //ValueFromIndex[values.Count-1]:= inttostr(i);
            //          ServerList[index].Memo.Lines.Add(inttostr(i)+'.: '+ values[values.Count-1]);
                      ParseScript(forlist[j],params,values,index);
                    end;
            //        for i:=0 to params.Count-1 do ServerList[index].Memo.Lines.Add(params[i] + ' -> ' + values[i]);
            //       ServerList[index].Memo.Lines.Add('endfor v�ge');
            //       continue;
                    inif:= ifstate;
                 end;

                if infor then
                begin
                 forlist.Add(sor);
                end;
            //}
            //    if not infor then
            ParseScript(sor, params, values, index); //,inif,voltmarif);

            //break;
          end; // if sor <> ''

        end;
      except
      end;
    finally
      CloseFile(F);
    end;
  end;

  params.Free;
  values.Free;

end;

procedure TForm1.ParseScript(sor: string; params, values: TStringList; index:
  integer); // inif, voltmarif: boolean);
var
  i: integer;
  f: TextFile;
  // kell: boolean;
  // inif, voltmarif: boolean;
begin
  //  inif:= false;
  //  voltmarif:= false;

  // for j:= 1 to loop do
  //  if sor <> '' then
  //  begin

      //////// COMMENTS ////////////

  // ignore commentlines starting with #
  if Matches('#*', sor) then
    exit;
  // and multiline comments
  if Matches('{*', sor) then
  begin
    inif := true;
    exit;
  end;

  ///////// replacing paramters with values /////////
  for i := 0 to params.Count - 1 do
    if Matches('*' + params[i] + '*', sor) then
    begin
      sor := AnsiReplaceStr(sor, params[i], values[i]);
    end;
  for i := params.Count - 1 downto 0 do
    if Matches('*' + params[i] + '*', sor) then
    begin
      sor := AnsiReplaceStr(sor, params[i], values[i]);
    end;

  /////////////  IF //////////////////

  if Matches('IF *', UpperCase(sor)) and not inif then
  begin

    voltmarif := true;
    Delete(sor, 1, 2);
    while Pos(' ', sor) = 1 do
      Delete(sor, 1, 1);
    while sor[length(sor)] = ' ' do
      Delete(sor, Length(sor), 1);

    ////////  ISSET /////////////////

    if Matches('ISSET *', UpperCase(sor)) then
    begin
      Delete(sor, 1, Length('ISSET '));
      while Pos(' ', sor) = 1 do
        Delete(sor, 1, 1);
      for i := 0 to values.Count - 1 do
      begin
        //      ServerList[index].Memo.Lines.Add(sor + ' vs. '+values[i]);
        if Matches(sor + '*', values[i]) then
        begin
          inif := false;
          break;
        end
        else
          inif := true;
      end;
    end;

    if Matches('NOT ISSET *', UpperCase(sor)) then
    begin
      Delete(sor, 1, Length('NOT ISSET '));
      while Pos(' ', sor) = 1 do
        Delete(sor, 1, 1);
      for i := 0 to values.Count - 1 do
      begin
        //      ServerList[index].Memo.Lines.Add(sor + ' vs. '+values[i]);
        if not Matches(sor + '*', values[i]) then
        begin
          inif := false;
          break;
        end
        else
          inif := true;
      end;
    end;

    //ServerList[index].Memo.Lines.Add(sor);

    for i := 0 to values.Count - 1 do
      if Matches(values[i] + '*', sor) then
      begin
        Delete(sor, 1, Length(values[i]));
        //ServerList[index].Memo.Lines.Add(sor);

        if Matches('*=*', sor) then
        begin
          Delete(sor, 1, Pos('=', sor));
          while Pos(' ', sor) = 1 do
            Delete(sor, 1, 1);
          if not Matches(sor, values[i]) then
            inif := true;
        end;

        if Matches('*>*', sor) and not Matches('*<>*', sor) then
        begin
          Delete(sor, 1, Pos('>', sor));
          //while Pos(' ',sor) = 1 do Delete(sor,1,1);
          sor := Trim(sor);

          try
            if not strtoint(sor) > strtoint(values[i]) then
              inif := true;
          except
          end;
          {
           if not StrComp(PChar(sor),PChar(values[i]))>0 then
             inif:= true;
           try
             if not strtoint(sor) > strtoint(values[i]) then
               inif:= true;
           except
             if not StrComp(PChar(sor),PChar(values[i]))>0 then
               inif:= true;
           end;
           if not strtoint(sor) > strtoint(values[i]) then
             inif:= true;
           voltmarif:= true;
           }
        end;

        if Matches('*<*', sor) and not Matches('*<>*', sor) then
        begin
          Delete(sor, 1, Pos('<', sor));
          //while Pos(' ',sor) = 1 do Delete(sor,1,1);
          sor := Trim(sor);

          try
            if not strtoint(sor) < strtoint(values[i]) then
              inif := true;
          except
          end;

          //      if not StrComp(PChar(sor),PChar(values[i]))<0 then inif:= true;
          //      voltmarif:= true;
        end;

        if Matches('*<>*', sor) then
        begin
          Delete(sor, 1, Pos('<>', sor) + 1);
          while Pos(' ', sor) = 1 do
            Delete(sor, 1, 1);
          if Matches(sor, values[i]) then
            inif := true;
          //      voltmarif:= true;
        end;

        var1 := sor;
        var2 := values[i];
      end;
    sor := '';
    //}
  end; //Matches 'if' sor

  /////////// ENDIF //////////////////

  if Matches('endif', LowerCase(sor)) then //and inif
  begin
    inif := false;
    voltmarif := false;
  end; //endif �s inif

  ///////// ELSE /////////////////

  if Matches('ELSE', UpperCase(sor)) and voltmarif then
  begin
    //    if inif then inif:= false
    //    else inif:= true;
    voltmarif := true;
    if Matches(var1, var2) then
      inif := true
    else
      inif := false;
    //sor:= '';
  end; //endif �s inif

  ///////// IRCMSG ////////////////////

  if Matches('IRCMSG *', UpperCase(sor)) and not inif then
  begin
    Delete(sor, 1, Length('IRCMSG '));
    //     Delete(sor,Length(sor),1);

    for i := 0 to params.Count - 1 do
      if Matches('*' + params[i] + '*', sor) then
      begin
        Insert(values[i], sor, Pos(params[i], sor));
        Delete(sor, Pos(params[i], sor), Length(params[i]));
      end;

    if IRC.Connected then
      IRCMsg(Config.IRC.Channel, sor);
    sor := '';
  end; //IRCMSG

  ///////////////// ADMINMSG ////////////////

  if Matches('ADMINMSG *', UpperCase(sor)) and not inif then
  begin
    Delete(sor, 1, Length('ADMINMSG '));
    //     Delete(sor,Length(sor),1);

    for i := 0 to params.Count - 1 do
      if Matches('*' + params[i] + '*', sor) then
      begin
        Insert(values[i], sor, Pos(params[i], sor));
        Delete(sor, Pos(params[i], sor), Length(params[i]));
      end;

    //     if not Form1.Visible then RestoreMainForm;
    if ServerTab.TabIndex <> index then
    begin
      ServerList[ServerTab.TabIndex].Memo.Visible := false;
      ServerTab.TabIndex := index;
      ServerTabChange(nil);
    end;
    //      AdminReq.Caption:= 'Admin request from ' + ServerTab.Tabs[index];
    AdminReq.Caption := 'Admin request from ' + ServerList[index].ServerName;
    AdminReq.Label1.Caption := sor;
    //      AdminReq.Show;
    //      AdminBubi.Title:= 'Admin request from ' + ServerTab.Tabs[index];
    AdminBubi.Title := 'Admin request from ' + ServerList[index].ServerName;
    if (Length(AdminBubi.Prompt.Text) + Length(sor) > 254) then
      while (Length(AdminBubi.Prompt.Text)) > 1 do
      begin
        AdminBubi.Prompt.Delete(0);
      end;
    AdminBubi.Prompt.Add(sor);
    if Config.SoundfileName <> '' then
      PlaySound(PAnsiChar(Config.SoundfileName), 0, SND_ASYNC)
    else
      PlaySound('SystemNotification', 0, SND_ASYNC);
    AdminBubi.Show(Screen.Width, Screen.Height - TaskBarHeight);
    //Beep;
    sor := '';
  end; //ADMINMSG

  // adding a timer.
  // usage: TIMER <TimerName> <repeat> <interval> <scriptfile>
  if Matches('TIMER * * * *', UpperCase(sor)) and not inif then
  begin
    Delete(sor, 1, Length('TIMER '));
    //     Delete(sor,Length(sor),1);

    for i := 0 to params.Count - 1 do
      if Matches('*' + params[i] + '*', sor) then
      begin
        Insert(values[i], sor, Pos(params[i], sor));
        Delete(sor, Pos(params[i], sor), Length(params[i]));
      end;

    params.add(Copy(sor, 1, Pos(' ', sor)));
    Delete(sor, 1, Length(params[params.Count - 1]));

    params.add(Copy(sor, 1, Pos(' ', sor)));
    Delete(sor, 1, Length(params[params.Count - 1]));

    params.add(Copy(sor, 1, Pos(' ', sor)));
    Delete(sor, 1, Length(params[params.Count - 1]));

    params.add(sor);

    params[params.Count - 1] := Trim(params[params.Count - 1]);
    params[params.Count - 2] := Trim(params[params.Count - 2]);
    params[params.Count - 3] := Trim(params[params.Count - 3]);
    params[params.Count - 4] := Trim(params[params.Count - 4]);
    {
          ShowMessage(params[params.Count-1]);
          ShowMessage(params[params.Count-2]);
          ShowMessage(params[params.Count-3]);
          ShowMessage(params[params.Count-4]);
    }

    AddARSSETimer(
      //        'Pr�ba','script/proba.txt',1,3000,true,index);

      params[params.Count - 4],
      params[params.Count - 1],
      strtoint(params[params.Count - 3]),
      strtoint(params[params.Count - 2]) * 1000,
      true,
      index

      );

    params.Delete(params.Count - 1);
    params.Delete(params.Count - 1);
    params.Delete(params.Count - 1);
    params.Delete(params.Count - 1);

    //      if IRC.Connected then IRCMsg(Config.IRC.Channel,sor);
    sor := '';
  end; //TIMER

  //////////////  KILL /////////////

  if Matches('KILL', UpperCase(sor)) and not inif then
  begin
    IRCConnectClick(nil);
  end;

  /////////////  HIDE ///////////

  if Matches('HIDE', UpperCase(sor)) and not inif then
  begin
    mutathatod := false;
  end;

  /////////////  HIDE LOG ///////////

  if Matches('HIDE LOG', UpperCase(sor)) and not inif then
  begin
    logolhatsz := false;
  end;

  ///////// CLEAR ////////////////////

  if Matches('CLEAR', UpperCase(sor)) and not inif then
  begin
    MemoAppend(index, ServerList[index].Memo.Font.Color, ''); //default textcolor fix
    ServerList[index].Memo.Clear;
    sor := '';
  end; //CLEAR

  ///////////////// WRITE /////////////

  if Matches('WRITE *', UpperCase(sor)) and not inif then
  begin
    Delete(sor, 1, Length('WRITE '));
    //     Delete(sor,Length(sor),1);

    for i := 0 to params.Count - 1 do
      if Matches('*' + params[i] + '*', sor) then
      begin
        Insert(values[i], sor, Pos(params[i], sor));
        Delete(sor, Pos(params[i], sor), Length(params[i]));
      end;

    MemoAppend(index, ServerList[index].Memo.Font.Color, '(' + FormatDateTime('HH:mm:ss', now) + ') ' + sor);
    //     ServerList[index].Memo.Lines.Append{bb}('(' + FormatDateTime('HH:mm:ss',now) + ') ' +sor);
    //     MemoAdd(ServerList[index].Memo,'(' + FormatDateTime('HH:mm:ss',now) + ') ' +sor);
    sor := '';
  end;

  ///////////////// WRITEFILE /////////////

  if Matches('WRITEFILE *', UpperCase(sor)) and not inif then
  begin
    Delete(sor, 1, Length('WRITEFILE '));

    Trim(sor);

    AssignFile(f, ExtractFilePath(Application.ExeName) + Copy(sor, 1, Pos(' ',
      sor)));

    if not FileExists(ExtractFilePath(Application.ExeName) + Copy(sor, 1,
      Pos(' ', sor))) then
      Rewrite(f)
    else
      Append(f);

    Delete(sor, 1, Length(Copy(sor, 1, Pos(' ', sor))));

    for i := 0 to params.Count - 1 do
      if Matches('*' + params[i] + '*', sor) then
      begin
        Insert(values[i], sor, Pos(params[i], sor));
        Delete(sor, Pos(params[i], sor), Length(params[i]));
      end;

    WriteLn(f, sor);
    Flush(f);

    CloseFile(f);

    //     ServerList[index].Memo.Lines.Add('(' + FormatDateTime('HH:mm:ss',now) + ') ' +sor);
    sor := '';
  end;

  ////////// / COMMANDS ////////////

  if Matches('/*', sor) and not inif then
  begin
    for i := 0 to params.Count - 1 do
      if Matches('*' + params[i] + '*', sor) then
      begin
        Insert(values[i], sor, Pos(params[i], sor));
        Delete(sor, Pos(params[i], sor), Length(params[i]));
      end;
    ServerList[index].Client.WriteLn(sor);
    ARSSECommands(sor, index);
    sor := '';
  end;

  // end; //of for

  //params.Free;
  //values.Free;
end;

procedure TForm1.Kill1Click(Sender: TObject);
var
  i: integer;
  S: string;
  ch: char;
begin
  if PlayerList.Items.Count = 0 then
    exit;
  i := PlayerList.Itemindex;
  if (i < 0) or (i > (PlayerList.Items.Count - 1)) then
    exit;

  S := PlayerList.Items[i].Caption;

  Cmd.Text := '/kill ' + S;
  ch := #13;
  CmdKeyPress(nil, ch);
end;

procedure TForm1.BalanceTeams(index: integer);
var
  i, a, b: integer;
begin

  a := 0;
  b := 0;

  //if (ServerList[index].RefreshMsg.GameStyle = 3) or (ServerList[index].RefreshMsg.GameStyle = 5) then
  //begin
  for i := 1 to MAX_PLAYERS do
  begin
    if ServerList[index].RefreshMsg.Team[i] = 1 then
      inc(a);
    if ServerList[index].RefreshMsg.Team[i] = 2 then
      inc(b);
  end;
  if (a + ServerList[index].Config.balancediff) <= b then //b nagyobb
  begin
    DoBalance(index, 2, a, b);
  end;
  if (b + ServerList[index].Config.balancediff) <= a then //a nagyobb
  begin
    DoBalance(index, 1, a, b);
  end;
  //end
  //else exit;

end;

procedure TForm1.DoBalance(index, team, a, b: integer);
var
  i, team2, osszes: integer;
  balanced: boolean;
begin
  balanced := false;
  osszes := a + b;
  osszes := osszes mod 2;
  case team of
    1:
      begin
        team2 := 2;
        b := b + osszes;
      end;
    2:
      begin
        team2 := 1;
        a := a + osszes;
      end;
  else
    team2 := 1;
  end;
  // repeat
  i := MAX_PLAYERS;
  repeat
    if ServerList[index].RefreshMsg.Team[i] = team then
    begin
      ServerList[index].Client.WriteLn('/setteam' + inttostr(team2) + ' ' +
        inttostr(ServerList[index].RefreshMsg.Number[i]));
      balanced := true;
      case team of
        1:
          begin
            inc(b);
            dec(a);
          end;
        2:
          begin
            inc(a);
            dec(b);
          end;
      end;
    end;
    dec(i);
  until (a = b) or (i = 1);
  // until (a = b);

  if balanced then
    ServerList[index].Client.WriteLn('/say Teams balanced.');
  RefreshClick(nil);

end;

procedure TForm1.BalanceTimerTimer(Sender: TObject);
begin
  BalanceTeams(current_server);
  BalanceTimer.Enabled := false;
end;

procedure TForm1.ConnectMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
    ConnectPopup.Popup(Form1.Left + Connect.Left + 25, Form1.Top + Connect.Top +
      Connect.Height + GroupBox2.Top +
      AddFavServ.Height + 28);
end;

procedure TForm1.ConnectAll1Click(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to ServerTab.Tabs.Count - 1 do
    if not ServerList[i].Client.Connected then
      if i = ServerTab.TabIndex then
        ConnectClick(nil)
      else //ServerList[i].Client.Connect();
      begin
        MemoAppend(i, ServerList[i].Memo.Font.Color, '(' + FormatDateTime('hh:mm:ss', now) + ') ' +
          'Connecting to ' + ServerList[i].Client.Host + ':' +
          inttostr(ServerList[i].Client.Port) + '...');
        //      ServerList[i].Memo.Lines.Append{bb}('(' + FormatDateTime('hh:mm:ss',now) + ') ' + 'Connecting to ' + ServerList[i].Client.Host + ':' + inttostr(ServerList[i].Client.Port) + '...');
        //      MemoAdd(ServerList[i].Memo,'(' + FormatDateTime('hh:mm:ss',now) + ') ' + 'Connecting to ' + ServerList[i].Client.Host + ':' + inttostr(ServerList[i].Client.Port) + '...');
        WriteToLog('Session Start: ' +
          FormatDateTime('ddd mmm dd hh:mm:ss yyyy', now), i);
        WriteToLog('(' + FormatDateTime('hh:mm:ss', now) + ') ' +
          'Connecting to ' + ServerList[i].Client.Host + ':' +
          inttostr(ServerList[i].Client.Port) + '...', i);

        try
          ServerList[i].Client.Connect;
        except
          MemoAppend(i, ServerList[i].Memo.Font.Color, '(' + FormatDateTime('hh:mm:ss', now) + ') ' +
            'Connection failed.');
          //        ServerList[i].Memo.Lines.Append{bb}('(' + FormatDateTime('hh:mm:ss',now) + ') ' + 'Connection failed.');
          //        MemoAdd(ServerList[i].Memo,'(' + FormatDateTime('hh:mm:ss',now) + ') ' + 'Connection failed.');

          WriteToLog('(' + FormatDateTime('hh:mm:ss', now) + ') ' +
            'Connection failed.', i);
          WriteToLog('Session Close: ' +
            FormatDateTime('ddd mmm dd hh:mm:ss yyyy', now), i);
          WriteToLog('', i);
        end;

      end;

end;

procedure TForm1.DisconnectAll1Click(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to ServerTab.Tabs.Count - 1 do
    if ServerList[i].Client.Connected then
      if i = ServerTab.TabIndex then
        ConnectClick(nil)
      else //ServerList[i].Client.Disconnect();
      begin
        ServerList[i].AutoRetryTimer.Tag := 101;
        try
          ServerList[i].Client.Disconnect;
        except
        end;
        MemoAppend(i, ServerList[i].Memo.Font.Color, '(' + FormatDateTime('HH:mm:ss', now) + ') ' +
          'Disconnected from ' + ServerList[i].Client.Host);
        //     ServerList[i].Memo.Lines.Append{bb}('(' + FormatDateTime('HH:mm:ss',now) + ') ' + 'Disconnected from ' + ServerList[i].Client.Host);
        //     MemoAdd(ServerList[i].Memo,'(' + FormatDateTime('HH:mm:ss',now) + ') ' + 'Disconnected from ' + ServerList[i].Client.Host);

        WriteToLog('(' + FormatDateTime('HH:mm:ss', now) + ') ' +
          'Disconnected from ' + ServerList[i].Client.Host, i);
        WriteToLog('Session Close: ' +
          FormatDateTime('ddd mmm dd hh:mm:ss yyyy', now), i);
        WriteToLog('', i);

      end;
end;

procedure TForm1.AutoRetryClick(Sender: TObject);
begin
  if ServerList[ServerTab.TabIndex].AutoRetry then
  begin
    ServerList[ServerTab.TabIndex].AutoRetry := false;
    AutoRetry.Checked := false;
  end
  else
  begin
    ServerList[ServerTab.TabIndex].AutoRetry := true;
    AutoRetry.Checked := true;
  end;
end;

procedure TForm1.AutoRetryTimer(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to ServerTab.Tabs.Count - 1 do
    if (Sender as TTimer).ComponentIndex =
      ServerList[i].AutoRetryTimer.ComponentIndex then
      if (Sender as TTimer).Tag = 101 then
      begin
        exit;
      end
      else
      begin
        MemoAppend(i, ServerList[i].Memo.Font.Color, '(' + FormatDateTime('hh:mm:ss', now) + ') ' +
          'Connecting to ' + ServerList[i].Client.Host + ':' +
          inttostr(ServerList[i].Client.Port) + '...');
        //    ServerList[i].Memo.Lines.Append{bb}('(' + FormatDateTime('hh:mm:ss',now) + ') ' + 'Connecting to ' + ServerList[i].Client.Host + ':' + inttostr(ServerList[i].Client.Port) + '...');
        //      MemoAdd(ServerList[i].Memo,'(' + FormatDateTime('hh:mm:ss',now) + ') ' + 'Connecting to ' + ServerList[i].Client.Host + ':' + inttostr(ServerList[i].Client.Port) + '...');

        WriteToLog('Session Start: ' +
          FormatDateTime('ddd mmm dd hh:mm:ss yyyy', now), i);
        WriteToLog('(' + FormatDateTime('hh:mm:ss', now) + ') ' +
          'Connecting to ' + ServerList[i].Client.Host + ':' +
          inttostr(ServerList[i].Client.Port) + '...', i);

        //      ServerList[i].Memo.Lines.Add( inttostr((Sender as TTimer).ComponentIndex) + ' ' + inttostr(ServerList[i].AutoRetryTimer.ComponentIndex) );

        try
          ServerList[i].Client.Connect;
        except
          MemoAppend(i, ServerList[i].Memo.Font.Color, '(' + FormatDateTime('hh:mm:ss', now) + ') ' +
            'Connection failed.');
          //        ServerList[i].Memo.Lines.Append{bb}('(' + FormatDateTime('hh:mm:ss',now) + ') ' + 'Connection failed.');
          //        MemoAdd(ServerList[i].Memo,'(' + FormatDateTime('hh:mm:ss',now) + ') ' + 'Connection failed.');

          WriteToLog('(' + FormatDateTime('hh:mm:ss', now) + ') ' +
            'Connection failed.', i);
          WriteToLog('Session Close: ' +
            FormatDateTime('ddd mmm dd hh:mm:ss yyyy', now), i);
          WriteToLog('', i);
        end;
        break;
      end;

  //ServerList[ServerTab.TabIndex].Memo.Lines.Add( inttostr((Sender as TTimer).ComponentIndex) + ' ' + inttostr(ServerList[1].AutoRetryTimer.ComponentIndex) );

  //inttostr((Sender as TTimer).ComponentIndex)
end;

procedure TForm1.AutoConnectClick(Sender: TObject);
begin
  if ServerList[ServerTab.TabIndex].AutoConnect then
  begin
    ServerList[ServerTab.TabIndex].AutoConnect := false;
    AutoConnect.Checked := false;
  end
  else
  begin
    ServerList[ServerTab.TabIndex].AutoConnect := true;
    AutoConnect.Checked := true;
  end;
end;

procedure TForm1.ServerTabDrawTab(Control: TCustomTabControl;
  TabIndex: Integer; const Rect: TRect; Active: Boolean);
var
  myRect: TRect;
begin
  try
    if Tabindex mod 2 = 0 then
    begin

    end;
    myRect := Rect;
    if ServerList[TabIndex].Client.Connected then
    begin
      if Active then
      begin
        Control.Canvas.Font.Color := $007F0E; //set green
        Control.Canvas.Brush.Color := $C6FFCF;
      end
      else
      begin
        Control.Canvas.Font.Color := $006A7F; //set yellow
        Control.Canvas.Brush.Color := $CCEFF1;
      end;
    end
    else if TabIndex = servertab.TabIndex then
    begin
      Control.Canvas.Font.Color := clHotLight; {clLtGray}
    end
    else
    begin
      Control.Canvas.Font.Color := clGray;
    end;
    //draws background and text
    Control.Canvas.TextRect(Rect, Rect.Left + (Rect.Right - Rect.Left -
      Control.Canvas.TextWidth(ServerTab.Tabs[TabIndex])) div
      2, Rect.Top + 3, ServerTab.Tabs[TabIndex]);
  except;
  end;

  if ServerList[ServerTab.TabIndex].RefreshMsgVers >= REFRESHX_270 then
    SetPlayerListColumnWidthAndMinwidth(COLUMN_TAGID, true)
  else
    SetPlayerListColumnWidthAndMinwidth(COLUMN_TAGID, false);

  if ServerList[ServerTab.TabIndex].RefreshMsgVers >= REFRESHX_265 then
    SetPlayerListColumnWidthAndMinwidth(COLUMN_CAPS, true)
  else
    SetPlayerListColumnWidthAndMinwidth(COLUMN_CAPS, false);
end;

procedure TForm1.Mute1Click(Sender: TObject);
var
  i: integer;
  S: string;
  ch: char;
begin
  if PlayerList.Items.Count = 0 then
    exit;
  i := PlayerList.Itemindex;
  if (i < 0) or (i > (PlayerList.Items.Count - 1)) then
    exit;

  S := PlayerList.Items[i].Caption;

  Cmd.Text := '/gmute ' + S;
  ch := #13;
  CmdKeyPress(nil, ch);

end;

procedure TForm1.Unmute1Click(Sender: TObject);
var
  i: integer;
  S: string;
  ch: char;
begin
  if PlayerList.Items.Count = 0 then
    exit;
  i := PlayerList.Itemindex;
  if (i < 0) or (i > (PlayerList.Items.Count - 1)) then
    exit;

  S := PlayerList.Items[i].Caption;

  Cmd.Text := '/ungmute ' + S;
  ch := #13;
  CmdKeyPress(nil, ch);
end;

procedure TForm1.PrivateMessage1Click(Sender: TObject);
var
  i: integer;
  S, amsg: string;
  ch: char;
begin
  if PlayerList.Items.Count = 0 then
    exit;
  i := PlayerList.Itemindex;
  if (i < 0) or (i > (PlayerList.Items.Count - 1)) then
    exit;

  S := PlayerList.Items[i].Caption;
  amsg := InputBox('Private Message to ' + PlayerList.Items[i].SubItems[ITEM_NAME],
    'Message', '');
  if amsg = '' then
    exit;
  Cmd.Text := '/pm ' + S + ' ' + amsg;
  ch := #13;
  CmdKeyPress(nil, ch);
end;

procedure TForm1.LoadCommandBox(filename: string);
var
  f: TextFile;
  s: string;
  kezdve: boolean;
  i: integer;
begin
  kezdve := false;
  i := -1;

  if not fileexists(filename) then
  begin
    inc(i);
    Config.CommandBox[i].Name := filename;
    Config.CommandBox[i].Commands := TStringList.Create;
    inc(i);
    Config.CommandBox[i].Name := 'not exists. Commands';
    Config.CommandBox[i].Commands := TStringList.Create;
    inc(i);
    Config.CommandBox[i].Name := 'wasn''t loaded.';
    Config.CommandBox[i].Commands := TStringList.Create;
  end;

  AssignFile(f, filename);
  Reset(f);

  while not Eof(f) do
  begin
    ReadLn(f, s);
    if not Matches('#*', s) and (s <> '') then
    begin
      s := Trim(s);
      //   if not kezdve and not (s = '') and not Matches('#*',s) then
      if not kezdve then
      begin
        inc(i);
        Config.CommandBox[i].Name := s;
        Config.CommandBox[i].Commands := TStringList.Create;
        kezdve := true;
      end
      else if s <> '{' then
        //if (not (s = '{')) and (not Matches('#*',s)) then
      begin
        if s = '}' then
          kezdve := false
        else
          Config.CommandBox[i].Commands.Add(s);
      end;
    end;
  end;

  CloseFile(f);

  ActionList.Clear;

  for i := 0 to 100 do
    if (Config.CommandBox[i].Name <> '') then
    begin
      ActionList.Items.Append(Config.CommandBox[i].Name);
    end;
end;

procedure TForm1.SaveCommandBox(filename: string);
var
  f: TextFile;
  //    s: string;
  //    kezdve: boolean;
  i, j: integer;
begin

  AssignFile(f, filename);

  //  if not FileExists(filename) then
  Rewrite(f);
  //  else Append(f);

  for i := 0 to ActionList.Count - 1 do
  begin
    WriteLn(f, Config.CommandBox[i].Name);
    WriteLn(f, '{');
    for j := 0 to Config.CommandBox[i].Commands.Count - 1 do
      WriteLn(f, Config.CommandBox[i].Commands[j]);
    WriteLn(f, '}');
    WriteLn(f, '');
  end;

  Flush(f);
  CloseFile(f);

end;

(*
procedure TForm1.LoadHotkeys(filename: string);
var
  f: TextFile;
  s: string;
  kezdve: boolean;
  i: integer;
begin
  kezdve := false;
  i := -1;

  if not fileexists(filename) then
  begin

  end;

  AssignFile(f, filename);
  Reset(f);

  while not Eof(f) do
  begin
    ReadLn(f, s);
    if not Matches('#*', s) and (s <> '') then
    begin
      s := Trim(s);
      //   if not kezdve and not (s = '') and not Matches('#*',s) then
      if not kezdve then
      begin
        inc(i);
        //      Config.Hotkeys[i].Hotkey. := s;
        Config.Hotkeys[i].Commands := TStringList.Create;
        kezdve := true;
      end
      else if s <> '{' then
        //   if (not (s = '{')) and (not Matches('#*',s)) then
      begin
        if s = '}' then
          kezdve := false
        else
          Config.CommandBox[i].Commands.Add(s);
      end;
    end;
  end;

  CloseFile(f);

  ActionList.Clear;

  for i := 0 to 100 do
    if (Config.CommandBox[i].Name <> '') then
    begin
      ActionList.Items.Append(Config.CommandBox[i].Name);
    end;
end;   *)

procedure TForm1.ActionListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  pt: TPoint;
  item: integer;
begin
  if Button = mbRight then
  begin
    pt.X := X;
    pt.Y := Y;
    item := ActionList.ItemAtPos(pt, true);
    if item <> -1 then
    begin
      ActionList.Selected[item] := true;
      pt := ActionList.ClientToScreen(pt);
      ActionList.PopupMenu.Popup(pt.x, pt.y);
    end;
  end;

  //if Cmd.Enabled then Cmd.SetFocus else Panel1.SetFocus;
end;

procedure TForm1.EditClick(Sender: TObject);
begin
  EditCmd.CmdName.Text := ActionList.Items[ActionList.ItemIndex];
  EditCmd.CmdEditor.Lines := Config.CommandBox[ActionList.Itemindex].Commands;
  EditCmd.item := ActionList.ItemIndex;
  EditCmd.Caption := 'Edit Command';
  EditCmd.ShowModal;
end;

procedure TForm1.Add2Click(Sender: TObject);
begin
  EditCmd.CmdName.Text := 'New Command';
  //ActionList.Items[ActionList.ItemIndex];
  EditCmd.CmdEditor.Lines.Clear;
  // Config.CommandBox[ActionList.Itemindex].Commands;
  EditCmd.item := -1; //ActionList.ItemIndex;
  EditCmd.Caption := 'Add Command';
  EditCmd.ShowModal;
end;

procedure TForm1.Remove3Click(Sender: TObject);
var
  i, index: integer;
begin
  index := ActionList.ItemIndex;
  if MessageDlg('Remove command: "' + ActionList.Items[index] + '"?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    ActionList.Items.Delete(index);
    for i := index to ActionList.Items.Count - 1 do
    begin
      Config.CommandBox[i] := Config.CommandBox[i + 1];
    end;
  end;
end;

procedure TForm1.ParseKills(msg: string; index: integer);
var
  t1, t2, i, j {,ind, tker}: integer;
  TKini: Tinifile;
  TKers: TStringList;
  // seged: string;

begin
  // ind:= 0;
  j := 1;
  // tker:= 0;
  Delete(msg, 1, Length('(11:11:11) '));
  // seged:=msg;

  t1 := strtoint(Copy(msg, Pos('(', msg) + 1, 1));
  t2 := strtoint(Copy(msg, Pos('killed (', msg) + Length('killed ('), 1));

  Delete(msg, 1, Length('(1) '));
  Delete(msg, Pos(' killed (', msg), Length(msg));

  if (t1 <> 0) and (t1 = t2) then
    // ServerList[ServerTab.TabIndex].Memo.Lines.Add('TeamKill!!');
  begin
    TKini := Tinifile.Create(ExtractFilePath(Application.ExeName) +
      'teamkillers.ini');
    TKers := TStringList.create;

    TKini.ReadSectionValues('TeamKills', TKers);

    i := 0;
    repeat
      if TKers.Values['Player' + inttostr(i)] = msg then
      begin
        j := strtoint(TKers.Values['Kills' + inttostr(i)]) + 1;
        break;
      end;

      inc(i);
    until (TKers.Values['Player' + inttostr(i)] = '');

    TKini.WriteString('TeamKills', 'Player' + inttostr(i), msg);
    TKini.WriteString('TeamKills', 'Kills' + inttostr(i), inttostr(j));

    TKini.Free;
    TKers.Free;

    {
      if j >= 6 then
      begin
       ServerList[index].Memo.SelAttributes.Color:= clRed;
       TextColor:= clRed;
       ServerList[index].Memo.Lines.Add('TEAMKILLER WARNING! ' + msg);
      end;
    }
  end;

end;

{ THESE FUNCTIONS ARE REMOVED FOR NOW
}

{
procedure TForm1.MakePrivateClick(Sender: TObject);
var
// i : integer;
 Passwd : string;
 ch : char;
begin
 RefreshClick(nil);

 //DialogButtonsS1();
 SetDialogButtons('false','Ok','Cancel','false',true);
 MyDialogBox.Caption:='Make Private';
 MyDialogBox.ParamLabel.Caption:='Enter new server password:';
 if  MyDialogBox.ShowModal = mrOK then Passwd:= MyDialogBox.ParamValue.Text
 else exit;

 Kickall('/kick', ServerTab.TabIndex);

  ch:= #13;
  Cmd.Text:= '/password ' + Passwd;
  CmdKeyPress(nil, ch);
end;
}

{
procedure TForm1.ShutdownClick(Sender: TObject);
begin
 if MessageDlg('Shutdown Server?',mtConfirmation, [mbNo, mbYes], 0) = mrYes then
  begin

 try
  ServerList[ServerTab.TabIndex].Client.WriteLn('SHUTDOWN');
  Connect.Caption:=  'Connect';
  EnableConnectButtons(true);
  EnableButtons(false);
  PlayerList.Clear;
 except
 end;

   end;
end;
}

{
procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
//var point: TPoint;
begin
{
 if X = WM_LBUTTONDBLCLK then
  RestoreMainForm
 else if X = WM_RBUTTONUP then
 begin
  ShowThePopup;
 end;
 }
//end;

procedure TForm1.PassKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  allapot: TKeyboardState;
begin
  HotKeyDown(Sender, Key, Shift);
  GetKeyboardState(allapot);
  if ((allapot[vk_Control] and 128) <> 0) then
    Pass.PasswordChar := #0
  else
    Pass.PasswordChar := '*';
end;

procedure TForm1.MoreInfoMouseEnter(Sender: TObject);
begin
  if MoreInfo.Caption <> 'less' then
  begin
    ActionList.Visible := false;
    InfoBox.Height := Action.Top - InfoBox.Top + Action.Height;
    MoreInfo.Font.Style := [fsUnderline];
    infoOn := true;
  end;
end;

procedure TForm1.MoreInfoMouseLeave(Sender: TObject);
begin
  if MoreInfo.Caption <> 'less..' then
  begin
    InfoBox.Height := 109;
    infoOn := false;
    ActionList.Visible := true;
    MoreInfo.Font.Style := [];
  end;
end;

procedure TForm1.MoreInfoClick(Sender: TObject);
begin
  if MoreInfo.Caption <> 'less..' then
  begin
    MoreInfo.Caption := 'less..';
    ActionList.Visible := false;
    InfoBox.Height := Action.Top - InfoBox.Top + Action.Height;
    MoreInfo.Font.Style := [fsUnderline];
    infoOn := true;
  end
  else
  begin
    MoreInfo.Caption := 'more..';
    InfoBox.Height := 109;
    MoreInfo.Font.Style := [];
    infoOn := false;
    ActionList.Visible := true;
  end;
end;

procedure TForm1.AddARSSETimer(name, script: string; timerloop: byte; interval:
  integer; enabled: boolean; index: integer);
begin
  if ServerList[index].TimerName.Count > MAX_TIMER then
    exit;

  with ServerList[index].Timers[ServerList[index].TimerName.Count] do
  begin

    Timer := TTimer.Create(Form1);
    Timer.OnTimer := ARSSETimerTimer;
    ServerList[index].TimerName.Add(name);

    Timer.Enabled := enabled;
    Timer.Interval := interval;
    ScriptFile := script;
    Loop := timerloop;
  end;

end;

procedure TForm1.FixNames(index: integer);
var
  i: integer;
begin
  for i := 1 to MAX_PLAYERS do
  begin
    {
      if Matches('*'#10'*',ServerList[index].RefreshMsg.Name[i]) then
      begin
        MemoAppend(index,'Hacker alert! IP: ' +inttostr(ServerList[ServerTab.TabIndex].RefreshMsg.IP[i][1])+'.'+inttostr(ServerList[ServerTab.TabIndex].RefreshMsg.IP[i][2])+'.'+inttostr(ServerList[ServerTab.TabIndex].RefreshMsg.IP[i][3])+'.'+inttostr(ServerList[ServerTab.TabIndex].RefreshMsg.IP[i][4])  );
    //  ServerList[index].Memo.Lines.Append('Hacker alert! IP: ' +inttostr(ServerList[ServerTab.TabIndex].RefreshMsg.IP[i][1])+'.'+inttostr(ServerList[ServerTab.TabIndex].RefreshMsg.IP[i][2])+'.'+inttostr(ServerList[ServerTab.TabIndex].RefreshMsg.IP[i][3])+'.'+inttostr(ServerList[ServerTab.TabIndex].RefreshMsg.IP[i][4])  );
    //  MemoAdd(ServerList[index].Memo,'Hacker alert! IP: ' +inttostr(ServerList[ServerTab.TabIndex].RefreshMsg.IP[i][1])+'.'+inttostr(ServerList[ServerTab.TabIndex].RefreshMsg.IP[i][2])+'.'+inttostr(ServerList[ServerTab.TabIndex].RefreshMsg.IP[i][3])+'.'+inttostr(ServerList[ServerTab.TabIndex].RefreshMsg.IP[i][4]) );
      end;
    }
    ServerList[index].RefreshMsg.Name[i] :=
      StringReplace(ServerList[index].RefreshMsg.Name[i], #10, '',
      [rfReplaceAll])
  end;
end;

procedure TForm1.MoveToNone1Click(Sender: TObject);
var
  i: Char;
begin
  i := '0';
  MoveToTeam(nil, i);
end;

procedure TForm1.AdminBubiClick(Sender: TObject);
begin
  AdminBubi.Prompt.Clear;
  AdminBubi.Prompt.Add('');
  if (GetAsyncKeyState(VK_CONTROL) and StrToInt('$8000')) <> 0 then
    RestoreMainForm;
end;

function TForm1.TaskBarHeight: integer;
var
  hTB: HWND; // taskbar handle
  TBRect: TRect; // taskbar rectangle
begin
  hTB := FindWindow('Shell_TrayWnd', '');
  if hTB = 0 then
    Result := 0
  else
  begin
    GetWindowRect(hTB, TBRect);
    Result := TBRect.Bottom - TBRect.Top;
  end;
end;

procedure TForm1.ClearConsoleClick(Sender: TObject);
//var
//vscrollpos:integer;
begin
  // FUX1
  //vscrollpos:=GetScrollPos(ServerList[ServerTab.TabIndex].Memo.Handle,SB_VERT);
  //SendMessage(ServerList[ServerTab.TabIndex].Memo.Handle, WM_VSCROLL, SB_NONE, 0);
  //SetScrollPos(ServerList[ServerTab.TabIndex].Memo.Handle,SB_VERT,vscrollpos,false);
  //SendMessage(ServerList[ServerTab.TabIndex].Memo.Handle, WM_VSCROLL, SB_LINEDOWN, 0);
  //ServerList[ServerTab.TabIndex].Memo.Lines.Add('FUXED');
  //SendMessage(ServerList[2].Memo.Handle, WM_VSCROLL, SB_BOTTOM, 0);
  ServerList[ServerTab.TabIndex].Memo.clear;
  ServerList[ServerTab.TabIndex].Memo.SelLength := 0;
end;

procedure TForm1.CmdKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  // if Ctrl and (Key=9) then ShowMessage('woot');
  HotKeyDown(Sender, Key, Shift);

  if ((Key = VK_DOWN) or (KEY = VK_UP)) and (Cmd.Items.IndexOf(Cmd.Text) = -1)
    and (Cmd.Text <> '') then
  begin
    Cmd.Items.Insert(0, Cmd.Text);
    Cmd.ItemIndex := Cmd.ItemIndex + 1;
    //   ServerList[ServerTab.TabIndex].Memo.Lines.Add(inttostr(Cmd.Items.IndexOf(Cmd.Text)));
  end;

  if not Cmd.DroppedDown then
  begin
    if Key = VK_DOWN then
      Key := VK_UP
    else if Key = VK_UP then
      Key := VK_DOWN;
  end;
  //for jumping to the first or last command when you are at the end of the list
  if Key = VK_UP then
  begin
    if Cmd.ItemIndex - 1 < 0 then
    begin
      Cmd.ItemIndex := Cmd.Items.Count - 1;
      Key := 0;
      PostMessage(cmd.Handle, WM_KEYDOWN, VK_END, 0);
    end;
  end
  else if Key = VK_DOWN then
  begin
    if Cmd.ItemIndex + 1 > Cmd.Items.Count - 1 then
    begin
      Cmd.ItemIndex := 0;
      Key := 0;
      PostMessage(cmd.Handle, WM_KEYDOWN, VK_END, 0);
    end;
  end;
  if (Key = VK_UP) or (Key = VK_DOWN) then
    PostMessage(cmd.Handle, WM_KEYDOWN, VK_END, 0);

  // fix for abnormal behavior for ctrl+home and others
  if Ctrl then
    case Key of
      vk_end: Key := 0;
      vk_next: Key := 0;
      vk_prior: Key := 0;
      vk_home: Key := 0;
    end;

end;

procedure TForm1.CmdChange(Sender: TObject);
begin
  if cmd.Text = '//' then
  begin
    cmd.Text := cmd.Items.Strings[0];
    cmd.SelStart := Length(cmd.Text);
  end;
  if (87 < Length(cmd.Text)) and (Copy(cmd.Text, 0, 4) = '/say') or
    (83 < Length(cmd.Text)) and (Copy(cmd.Text, 0, 4) = '/pm ') then
  begin
    cmd.Color := $00FF7575;
    cmd.Font.Color := clWhite
  end
  else
  begin
    cmd.Color := clWindow;
    cmd.Font.Color := clWindowText;
  end;
end;

procedure TForm1.TimedIP1Click(Sender: TObject);
var
  i: integer;
  S, time: string;
  ch: char;
begin
  if PlayerList.Items.Count = 0 then
    exit;
  i := PlayerList.Itemindex;
  if (i < 0) or (i > (PlayerList.Items.Count - 1)) then
    exit;

  S := PlayerList.Items[i].SubItems[ITEM_IP];

  time := InputBox('Time to ban IP in minutes',
    'Ban time in minutes. -1 for permanent ban', '');

  if time = '' then
    exit;

  Cmd.Text := '/tempban ' + time + ' ' + S;
  ch := #13;
  CmdKeyPress(nil, ch);
  Kick1Click(Sender);
end;

procedure TForm1.ActionListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  text: string;
begin
  text := (Control as TListBox).Items[Index];
  with (Control as TListBox).Canvas do
    { draw on control canvas, not on the form }
  begin
    FillRect(Rect); { clear the rectangle }

    if not (Control as TListBox).Enabled then
      (Control as TListBox).Canvas.Font.Color := clActiveBorder;
    //clInactiveCaptionText;

    if Matches('- *', (Control as TListBox).Items[Index]) then
    begin
      (Control as TListBox).Canvas.Font.Style := [fsBold];
      text := StringReplace((Control as TListBox).Items[Index], '- ', '', []);
    end;
    TextOut(Rect.Left + 2, Rect.Top, text); { display the text }

  end;

end;

procedure TForm1.Reloadlist1Click(Sender: TObject);
begin
  LoadCommandBox(ExtractFilePath(Application.ExeName) + 'CommandBox.txt');
end;

procedure TForm1.ManualUpdateClick(Sender: TObject);
//begin
//  procedure TDownloadThread.Execute;
//const
//VERSIONINFO = '01.02.07.02';
//var
{  IdHttp1: TIdHTTP;
  FileS  : TFileStream;
  F      : TextFile;
  FARSSE : file;

  text, filename   : string;
  c: array [0..MAX_PATH] of char;
  allowupdate, needrestart: boolean;
}

begin

  if not Assigned(UpdtThread) then
  begin

    // ShowMessage(Sender.ClassName);

    UpdtThread := TUpdateThread.Create(True);
    if Sender.ClassName = 'TForm1' then
      UpdtThread.IsAuto := true
    else
      UpdtThread.IsAuto := false;
    UpdtThread.FreeOnTerminate := false;

    try
      //    FUpdateActive:= true;
      //    UpdtThread.OnTerminate:= HandleUpdateTerminate;
      UpdtThread.Resume;
      Config.updatetime := Date;
    except
      begin
        UpdtThread.Free;
        UpdtThread := nil;
        ShowMessage('Some error happened to the update thread!');
      end;
    end;
  end
  else
    ShowMessage('Update in process! Please wait ;)');
  {
  // download info file
  // compare with current version
  // if newer download update.exe
  // run exe
  // quit arsse

  // variable init

     GetTempPath(SizeOf(c)-1,c);
     allowupdate:= false;
     needrestart:= false;

  // download info file

  //  Label10.Caption:='Checking for updates...';
    IdHttp1:=TIdHttp.Create(nil);
    FileS:=TFileStream.Create(StrPas(c)+'update.dat', fmcreate);
    IdHttp1.Get('http://arsse.u13.net/update.dat', FileS);
    FileS.Free;
    if fileexists(StrPas(c)+'update.dat') then
    begin
  //   ProgressBar1.Position:=5;
     AssignFile(F, StrPas(c)+'update.dat');
     FileMode := fmOpenRead;
     Reset(F);
     while not Eof(F) do
     begin
      ReadLn(F, text);
  //    ShowMessage(text);
  //    ShowMessage(Copy(text,1, Pos('|',text)-1));
  //    if ((text[1]='v') and (text[4]='.') and (text[7]='.') and (text[10]='.') and (text[13]='|') and (text[14]='h') and (text[15]='t') and (text[16]='t') and (text[17]='p') and (text[18]=':') and (text[19]='/') and (text[20]='/') and (text[Length(text)]='^') and (text[Length(text)-4]='.')) then
      if Form1.Matches('v*.*.*.*|http://*/*.*^', text) then
      begin

  //  ShowMessage(Copy(text,1, Pos('|',text)) + ' ' + inttostr(Pos('|',text)));
      filename:= Copy(text,Pos('|',text)+1,Pos('^',text)-Pos('|',text)-1 );
      while Pos('/',filename) > 0 do
      begin
       filename:= Copy(filename,Pos('/',filename)+1,Length(filename) );
      end;
  //    ShowMessage(filename);
  //    ShowMessage(Copy(text,1, Pos('|',text)));
      if (AnsiCompareText('v'+VERSION+'.'+VERSIONBUILD,Copy(text,1, Pos('|',text)-1)))<0 then
       begin
  //      ProgressBar1.Position:=10;
        if allowupdate or (IDYes=MessageBoxA(Application.Handle,'New Version of ARSSE available! Do you wish to download updates?','New version of ARSSE',MB_YesNo+MB_IconQuestion+MB_DefButton2)) then
        begin
         allowupdate:= true;
  //       ProgressBar1.Position:=15;
  //       Label10.Caption:='Downloading updates...';
         //ShowMessage(Copy(text,pos('|',text)+1,Length(text)-1-pos('|',text)));
         if filename=ExtractFileName(Application.ExeName) then
         begin
           AssignFile(FARSSE, filename);
           Rename(FARSSE, filename+'_old');
           needrestart:= true;
         end;
         if not FileExists(ExtractFilePath(Application.ExeName)+filename) then FileS:=TFileStream.Create(ExtractFilePath(Application.ExeName)+filename, fmcreate)
         else FileS:=TFileStream.Create(ExtractFilePath(Application.ExeName)+filename, fmOpenWrite);
         IdHttp1.Get(Copy(text,pos('|',text)+1,Length(text)-1-pos('|',text)), FileS);
         FileS.Free;
  {       while IsFileInUse(ExtractFilePath(Application.ExeName)+filename) do
         begin
          if ProgressBar1.Position<100 then
          ProgressBar1.Position:=ProgressBar1.Position+5;
          sleep(10);
         end;
  }
  {      end
        else
        begin
  //       Label10.Caption:='...';
         break;
        end
       end
       else
        begin
          ShowMessage('Your version is up-to-date.');
          break;
        end;
      end;
     end;
     CloseFile(F);
     Erase(F);
     if needrestart and (IDYes=MessageBoxA(Application.Handle,'Update finished, and ARSSE needs a restart. Do you wish to restart now?','Restart',MB_YesNo+MB_IconQuestion+MB_DefButton2)) then
     begin
       // need to close connection to servers first, then restart ARSSE
       // this is left out untill multithreading is implemented
       ShellExecute(0,Nil,PChar('ARSSE.exe'),Pchar(''),Pchar(''),SW_NORMAL);
       Application.Terminate;
     end
     else if allowupdate then ShowMessage('Update finished! If you wish, you can restart ARSSE to make sure the changes apply.');

     end
    else
    begin
  //  Label10.Caption:='Update-file error...';
    end;
    }
end;
//end;

procedure TForm1.HandleUpdateCompletion(var Message: TMessage);
begin
  if Assigned(UpdtThread) then
  begin
    UpdtThread.WaitFor;
    // Config.updatetime:= UpdtThread.UpdateTime;
    UpdtThread.Free;
    UpdtThread := nil;
  end;
end;

{procedure TForm1.FixTrayIcon(var Message: TMessage);
begin
  if Message = WM_TASKBARCREATED then

end;

{
procedure TForm1.HandleUpdateTerminate(Sender: TObject);
begin
  FUpdateActive:= false;

end;
}

procedure TForm1.HandleHotKey(Key: Word);
begin
  case Key of
  // ban selected player
    0: if (PlayerList.Selected <> nil) and (MessageDlg('Ban ' +
      PlayerList.Selected.SubItems[0] + '?', mtConfirmation,
      [mbYes, mbNo], 0) = mrYes) then
        begin
          ServerList[ServerTab.TabIndex].Client.WriteLn('/ban ' +
            PlayerList.Selected.SubItems[0]);
        end;
      // connect to server
      1: if not ServerList[ServerTab.TabIndex].Client.Connected then
          ConnectClick(nil);
      // disconnect from server
      2: if ServerList[ServerTab.TabIndex].Client.Connected and
        (MessageDlg('Disconnect from ' +
          ServerList[ServerTab.TabIndex].ServerName + '?', mtConfirmation,
          [mbYes, mbNo], 0) = mrYes) then
          ConnectClick(nil);
      // toggle chat mode
      3: if Cmd.Enabled then
        begin
          SayBox.Checked := (not SayBox.Checked);
          SayBoxClick(Form1);
        end;
      // memo scroll to bottom
      4: ServerList[ServerTab.TabIndex].Memo.Perform(WM_VSCROLL, SB_BOTTOM,
          0);
      // show search window
      5:
        begin
          Memo.HideSelection := false;
          SearchForm1.Show;
          SearchForm1.Input.SetFocus;
        end;
      // memo scroll to top
      6: ServerList[ServerTab.TabIndex].Memo.Perform(WM_VSCROLL, SB_TOP,
          0);
      // expand server info-bar
      7: if infoON then
          MoreInfoMouseLeave(nil)
        else
          MoreInfoMouseEnter(nil);
      // kick selected player
      8: if (PlayerList.Selected <> nil) and (MessageDlg('Kick ' +
          PlayerList.Selected.SubItems[0] + '?', mtConfirmation,
          [mbYes, mbNo], 0) = mrYes) then
        begin
          ServerList[ServerTab.TabIndex].Client.WriteLn('/kick ' +
            PlayerList.Selected.SubItems[0]);
        end;
      // toggle nick chat mode
      9: if Cmd.Enabled then
        begin
          NickSayBox.Checked := (not NickSayBox.Checked);
          NickSayBoxClick(Form1);
        end;
      // set /password
      10: if ServerList[ServerTab.TabIndex].Client.Connected then
        begin
          if Cmd.Text = '' then
            Cmd.Text := '/password ';
          Cmd.SetFocus;
          Cmd.SelLength := 0;
          Cmd.SelStart := Length(Cmd.Text);
        end;
      // memo scroll to next page
      11: ServerList[ServerTab.TabIndex].Memo.Perform(WM_VSCROLL,
          SB_PAGEDOWN, 0);
      // memo scroll to previos page
      12: ServerList[ServerTab.TabIndex].Memo.Perform(WM_VSCROLL,
          SB_PAGEUP, 0);
      // recompile script
      13: if ServerList[ServerTab.TabIndex].Client.Connected then
        begin
          ServerList[ServerTab.TabIndex].Client.WriteLn('/recompile');
        end;
      // set /say
      14: if ServerList[ServerTab.TabIndex].Client.Connected then
        begin
          if Cmd.Text = '' then
            Cmd.Text := '/say ';
          if not Cmd.Focused then
            Cmd.SetFocus;
          Cmd.SelLength := 0;
          Cmd.SelStart := Length(Cmd.Text);
        end;
      // toggle admin chat mode
      15: if Cmd.Enabled then
        begin
          AdminBox.Checked := (not AdminBox.Checked);
          AdminBoxClick(Form1);
        end;
      // send pm to seleceted player
      16: if PlayerList.Selected <> nil then
        begin
          Cmd.Text := '/pm ' + PlayerList.Selected.Caption + ' ';
          Cmd.SetFocus;
          Cmd.SelLength := 0;
          Cmd.SelStart := Length(Cmd.Text);
        end;
      // send clientlist command
      17: if ServerList[ServerTab.TabIndex].Client.Connected then
        begin
          ServerList[ServerTab.TabIndex].Client.WriteLn('/clientlist');
        end;
    end;
end;

procedure TForm1.HotKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  AllowChange: boolean;
  i: integer;
begin
  //if (Key = (vk_home)) and (Key = vk_control) then Cmd.SetFocus;
  //ShowMessage(intToStr(Key));
  AllowChange := true;
  if not (Sender.ClassNameIs('TComboBox') or Sender.ClassNameIs('TEdit')) then
    case Key of
      // removed, useless now when cmd has focus all the time.
      // {'/'}    111 : if ServerList[ServerTab.TabIndex].Client.Connected then begin if Cmd.Text='' then Cmd.Text:= '/'; Cmd.SetFocus; Cmd.SelLength:=0; Cmd.SelStart:=Length(Cmd.Text); end;
      // connect to server
       Word('c'): if not ServerList[ServerTab.TabIndex].Client.Connected then
          ConnectClick(nil);
       //change to left tab
      vk_left: if ServerTab.TabIndex > 0 then
          // begin ServerTab.TabIndex:=ServerTab.TabIndex-1; ServerTabChange(nil); end;
        begin
          ServerTabChanging(nil, AllowChange);
          ServerTab.TabIndex := ServerTab.TabIndex - 1;
          ClickedTab := ServerTab.TabIndex;
          ServerTabChange(nil);
        end;
      //change to right tab
      vk_right: if ServerTab.TabIndex < ServerTab.Tabs.Count then
          // begin ServerTab.TabIndex:=ServerTab.TabIndex+1; ServerTabChange(nil); end;
        begin
          ServerTabChanging(nil, AllowChange);
          ServerTab.TabIndex := ServerTab.TabIndex + 1;
          ClickedTab := ServerTab.TabIndex;
          ServerTabChange(nil);
        end;
    end;

  // check hotkeys
  for i:=0 to 31 do
  begin
    if (shift=Config.Hotkeys[i].Shift) and (Key=Config.Hotkeys[i].Key) then
    begin
      HandleHotKey(i);
    end;
  end;

  (*
  if Ctrl then
  begin
    case Key of
      // set /say
      Word('T'): if ServerList[ServerTab.TabIndex].Client.Connected then
        begin
          if Cmd.Text = '' then
            Cmd.Text := '/say ';
          if not Cmd.Focused then
            Cmd.SetFocus;
          Cmd.SelLength := 0;
          Cmd.SelStart := Length(Cmd.Text);
        end;
      // ban selected player
      Word('B'): if (PlayerList.Selected <> nil) and (MessageDlg('Ban ' +
          PlayerList.Selected.SubItems[0] + '?', mtConfirmation,
          [mbYes, mbNo], 0) = mrYes) then
        begin
          ServerList[ServerTab.TabIndex].Client.WriteLn('/ban ' +
            PlayerList.Selected.SubItems[0]);
        end;
      // kick selected player
      Word('K'): if (PlayerList.Selected <> nil) and (MessageDlg('Kick ' +
          PlayerList.Selected.SubItems[0] + '?', mtConfirmation,
          [mbYes, mbNo], 0) = mrYes) then
        begin
          ServerList[ServerTab.TabIndex].Client.WriteLn('/kick ' +
            PlayerList.Selected.SubItems[0]);
        end;
      // recompile script
      Word('R'): if ServerList[ServerTab.TabIndex].Client.Connected then
        begin
          ServerList[ServerTab.TabIndex].Client.WriteLn('/recompile');
        end;
      // toggle chat mode
      Word('E'):
        begin
          if Cmd.Enabled then
          begin
            SayBox.Checked := (not SayBox.Checked);
            SayBoxClick(Form1);
          end;
        end;
      // toggle nick chat mode
      Word('N'):
        begin
          if Cmd.Enabled then
          begin
            NickSayBox.Checked := (not NickSayBox.Checked);
            NickSayBoxClick(Form1);
          end;
        end;
      // toggle admin chat mode
      Word('W'):
        begin
          if Cmd.Enabled then
          begin
            AdminBox.Checked := (not AdminBox.Checked);
            AdminBoxClick(Form1);
          end;
        end;
      // send clientlist command
      Word('L'):
        begin
          if ServerList[ServerTab.TabIndex].Client.Connected then
          begin
            ServerList[ServerTab.TabIndex].Client.WriteLn('/clientlist');
          end;
        end;
      // send pm to seleceted player
      Word('Z'): if PlayerList.Selected <> nil then
        begin
          Cmd.Text := '/pm ' + PlayerList.Selected.Caption + ' ';
          Cmd.SetFocus;
          Cmd.SelLength := 0;
          Cmd.SelStart := Length(Cmd.Text);
        end;
      // set /password
      Word('P'): if ServerList[ServerTab.TabIndex].Client.Connected then
        begin
          if Cmd.Text = '' then
            Cmd.Text := '/password ';
          Cmd.SetFocus;
          Cmd.SelLength := 0;
          Cmd.SelStart := Length(Cmd.Text);
        end;
      // disconnect from server
      Word('D'): if ServerList[ServerTab.TabIndex].Client.Connected and
        (MessageDlg('Disconnect from ' +
          ServerList[ServerTab.TabIndex].ServerName + '?', mtConfirmation,
          [mbYes, mbNo], 0) = mrYes) then
          ConnectClick(nil);
      // expand server info-bar
      Word('I'): if infoON then
          MoreInfoMouseLeave(nil)
        else
          MoreInfoMouseEnter(nil);
      // show search window
      Word('F'):
        begin
          SearchForm1.Show;
          SearchForm1.Input.SetFocus;
        end;
      // select text
      Word('A'): if (Sender.ClassType = TEdit) then
          (Sender as TEdit).SelectAll
        else if (Sender.ClassType = TComboBox) then
          (Sender as TComboBox).SelectAll
        else if (Sender.ClassType = TRichEdit) then
          (Sender as TRichEdit).SelectAll;
      // focus command edit
      Word('1') {49}: if Cmd.Enabled then
          Cmd.SetFocus;
      // focus playerlsit
      Word('2'): if PlayerList.Enabled then
          PlayerList.SetFocus;
      // focus actionlist
      Word('3'): if ActionList.Enabled then
          ActionList.SetFocus;
      // focus  host field
      Word('4'): if Host.Enabled then
          Host.SetFocus;
      // focus servertabs
      Word('5'): if ServerTab.Enabled then
          ServerTab.SetFocus;
      // toggle server/irc tab
      Word('6'): if PageControl.ActivePage = ServerConsole then
          PageControl.ActivePage := BotConsole
        else
          PageControl.ActivePage := ServerConsole;

      // vk_tab: PlayerList.SetFocus;

      // memo scroll to top
      vk_home: ServerList[ServerTab.TabIndex].Memo.Perform(WM_VSCROLL, SB_TOP,
          0);
      // memo scroll to bottom
      vk_end: ServerList[ServerTab.TabIndex].Memo.Perform(WM_VSCROLL, SB_BOTTOM,
          0);
      // memo scroll to next page
      vk_next: ServerList[ServerTab.TabIndex].Memo.Perform(WM_VSCROLL,
          SB_PAGEDOWN, 0);
      // memo scroll to previos page
      vk_prior: ServerList[ServerTab.TabIndex].Memo.Perform(WM_VSCROLL,
          SB_PAGEUP, 0);
      // copy text
      vk_insert:
        begin
          if (Sender.ClassType = TComboBox) then
            Clipboard.SetTextBuf(PChar((Sender as TComboBox).Text));
          if (Sender.ClassType = TEdit) then
            Clipboard.SetTextBuf(PChar((Sender as TEdit).Text));
        end;
      // vk_space: if Cmd.Enabled then begin  Cmd.Text:= ' '; if not Cmd.Focused then Cmd.SetFocus; Cmd.SelLength:=0; Cmd.SelStart:=Length(Cmd.Text); end;
    end;


    //Key:= 0;
  end;*)
end;

procedure TForm1.FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
//var cmdfocus: boolean;
begin
  // cmdfocus:= Cmd.Focused;
  if Cmd.DroppedDown then
    exit;

  // Panel1.SetFocus; // what was that good for?

  if not ActionList.Focused and not PlayerList.Focused then
  begin
    Handled := false;
    //Cmd.SetFocus;
    Handled := true;
  end;

  if (ControlAtPos(ScreenToClient(MousePos), true, true) = ServerTab) and
    (ServerTab.TabIndex < ServerTab.Tabs.Count - 1) then
  begin
    ServerTabChanging(nil, Handled);
    ServerTab.TabIndex := ServerTab.TabIndex + 1;
    ClickedTab := ServerTab.TabIndex;
    ServerTabChange(nil);
  end;
  if PageControl.TabIndex = 1 then
    IRCConsole.Perform(WM_VSCROLL, SB_LINEDOWN, 0)
  else if not (ServerConsole.ControlAtPos(ScreenToClient(MousePos), false, true)
    = nil) then
    ServerConsole.ControlAtPos(ScreenToClient(MousePos), false,
      true).Perform(WM_VSCROLL, SB_LINEDOWN, 0);

  if (ServerConsole.ControlAtPos(ScreenToClient(MousePos), false, true) <>
    PlayerList) or
    (ServerConsole.ControlAtPos(ScreenToClient(MousePos), false, true) <>
    ActionList) or
    (ServerConsole.ControlAtPos(ScreenToClient(MousePos), false, true).ClassType
    <> TRichEdit) then
    SetFocusToCmd(Sender);

  //  if (ServerConsole.ControlAtPos(ScreenToClient(MousePos),true,true)=ActionList) then ShowMessage('omg!');
  //  ShowMessage(ControlAtPos(ScreenToClient(MousePos),true,true).ClassName );
  //  ShowMessage(ServerConsole.Controls[6].Name);
  //  SetFocusToCmd(Form1);
end;

procedure TForm1.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  if Cmd.DroppedDown then
    exit;

  // Panel1.SetFocus; // what was that good for?
  
  if not ActionList.Focused and not PlayerList.Focused then
  begin
    Handled := false;
    //Cmd.SetFocus;
    Handled := true;
  end;

  if (ControlAtPos(ScreenToClient(MousePos), true, true) = ServerTab) and
    (ServerTab.TabIndex > 0) then
  begin
    ServerTabChanging(nil, Handled);
    ServerTab.TabIndex := ServerTab.TabIndex - 1;
    ClickedTab := ServerTab.TabIndex;
    ServerTabChange(nil);
  end;
  if PageControl.TabIndex = 1 then
    IRCConsole.Perform(WM_VSCROLL, SB_LINEUP, 0)
  else if not (ServerConsole.ControlAtPos(ScreenToClient(MousePos), false, true)
    = nil) then
    ServerConsole.ControlAtPos(ScreenToClient(MousePos), false,
      true).Perform(WM_VSCROLL, SB_LINEUP, 0);

  if (ServerConsole.ControlAtPos(ScreenToClient(MousePos), false, true) <>
    PlayerList) or
    (ServerConsole.ControlAtPos(ScreenToClient(MousePos), false, true) <>
    ActionList) or
    (ServerConsole.ControlAtPos(ScreenToClient(MousePos), false, true).ClassType
    <> TRichEdit) then
    SetFocusToCmd(Sender);

  //  SetFocusToCmd(Form1);

end;

procedure TForm1.DuplicateServer1Click(Sender: TObject);
var
  i, j: shortint;
begin
  i := ServerTab.Tabs.Count;
  ServerTab.Tabs.Add(ServerList[ClickedTab].ServerName);

  ServerList[i].Config.AutoMessageList := TStringList.Create;

  for j := 0 to ServerList[ClickedTab].Config.AutoMessageList.Count - 1 do
  begin
    ServerList[i].Config.AutoMessageList.Add(ServerList[ClickedTab].Config.AutoMessageList.Strings[j]);
  end;

  ServerList[i].Config.EventFile := TStringList.Create;
  ServerList[i].Config.Events := TStringList.Create;

  ServerList[i].ServerName := ServerList[ClickedTab].ServerName;
  //'Server' + inttostr(i+1);

  for j := 0 to ServerList[ClickedTab].Config.Events.Count - 1 do
  begin
    ServerList[i].Config.Events.Add(ServerList[ClickedTab].Config.Events.Strings[j]);
    ServerList[i].Config.EventFile.Add(ServerList[ClickedTab].Config.EventFile.Strings[j]);
  end;

  ServerList[i].AutoRetryTimer := TTimer.Create(Form1);
  ServerList[i].AutoRetryTimer.OnTimer := AutoRetryTimer;
  ServerList[i].AutoRetryTimer.Enabled :=
    ServerList[ClickedTab].AutoRetryTimer.Enabled;
  ServerList[i].AutoRetryTimer.Interval :=
    ServerList[ClickedTab].AutoRetryTimer.Interval;

  ServerList[i].TimerName := TStringList.Create;

  for j := 0 to ServerList[ClickedTab].TimerName.Count - 1 do
  begin
    ServerList[i].TimerName.Add(ServerList[ClickedTab].TimerName.Strings[j]);
    ServerList[i].Timers[j].Timer := TTimer.Create(Form1);
    ServerList[i].Timers[j].Timer.OnTimer :=
      ServerList[ClickedTab].Timers[j].Timer.OnTimer;
    ServerList[i].Timers[j].Timer.Enabled :=
      ServerList[ClickedTab].Timers[j].Timer.Enabled;
    ServerList[i].Timers[j].Timer.Interval :=
      ServerList[ClickedTab].Timers[j].Timer.Interval;
    ServerList[i].Timers[j].ScriptFile :=
      ServerList[ClickedTab].Timers[j].ScriptFile;
    ServerList[i].Timers[j].Loop := ServerList[ClickedTab].Timers[j].Loop;
  end;

  ServerList[i].AutoSay := TTimer.Create(Form1);
  ServerList[i].AutoSay.OnTimer := ServerList[ClickedTab].AutoSay.OnTimer;
  ServerList[i].AutoSay.Enabled := ServerList[ClickedTab].AutoSay.Enabled;
  ServerList[i].AutoSay.Interval := ServerList[ClickedTab].AutoSay.Interval;

  ServerList[i].Client := TIdTCPClient.Create(Form1);
  ServerList[i].Client.Port := ServerList[ClickedTab].Client.Port;
  ServerList[i].Client.Host := ServerList[ClickedTab].Client.Host;

  ServerList[i].Memo := TRichEdit.Create(ServerConsole);
  ServerList[i].Memo.Parent := ServerConsole;
  ServerList[i].Memo.TabOrder := 100;
  ServerList[i].Memo.TabStop := false;
  ServerList[i].Memo.Width := Memo.Width;
  ServerList[i].Memo.Height := Memo.Height;
  ServerList[i].Memo.Left := Memo.Left;
  ServerList[i].Memo.Top := Memo.Top;
  ServerList[i].Memo.Visible := false;
  ServerList[i].Memo.Color := Config.ColorMain; // Memo.Color;
  ServerList[i].Memo.ReadOnly := true;
  ServerList[i].Memo.Font := Memo.Font;
  ServerList[i].Memo.Font.Color := Config.ColorText;
  ServerList[i].Memo.ScrollBars := ssVertical;
  ServerList[i].Memo.Constraints := Memo.Constraints;
  ServerList[i].Memo.OnChange := MemoChange;
  // ServerList[i].Memo.OnKeyDown:= MemoKeyDown;
  ServerList[i].Memo.OnKeyPress := HotKeyPress;
  ServerList[i].Memo.OnMouseUp := MemoMouseUp;
  ServerList[i].Memo.OnMouseDown := MemoMouseDown;
  // ServerList[i].Memo.OnEnter:= MemoEnter;
  // ServerList[i].Memo.OnExit:= MemoExit;

  ServerList[i].Client.OnConnected := ClientConnected;
  ServerList[i].Client.OnDisconnected := ClientDisconnected;
  ServerList[i].Config.balancediff := ServerList[ClickedTab].Config.balancediff;
  ServerList[i].Config.savepass := ServerList[ClickedTab].Config.savepass;
  ServerList[i].Config.savelog := ServerList[ClickedTab].Config.savelog;
  ServerList[i].Config.hideRegistered :=
    ServerList[ClickedTab].Config.hideRegistered;
  ServerList[i].Config.autobalance := ServerList[ClickedTab].Config.autobalance;
  ServerList[i].Config.autoswap := ServerList[ClickedTab].Config.autoswap;
  ServerList[i].Config.autosay := ServerList[ClickedTab].Config.autosay;
  ServerList[i].Config.AutoMsgDelay :=
    ServerList[ClickedTab].Config.AutoMsgDelay;
  ServerList[i].Config.AutoMessageList := TStringList.Create;
  ServerList[i].Pass := ServerList[ClickedTab].Pass;
  ServerList[i].AutoConnect := ServerList[i].AutoConnect;
  ServerList[i].joinedPlayerNicks := TStringList.Create;

  for j := 0 to ServerList[ClickedTab].Config.AutoMessageList.Count - 1 do
    ServerList[i].Config.AutoMessageList.Add(ServerList[ClickedTab].Config.AutoMessageList.Strings[j]);

  // AddServerClick(Sender);

  {
   ServerList[ServerTab.Tabs.Count-1].Config := ServerList[ClickedTab].Config;
   ServerList[ServerTab.Tabs.Count-1].Client.Host:= ServerList[ClickedTab].Client.Host;
   ServerList[ServerTab.Tabs.Count-1].Client.Port:= ServerList[ClickedTab].Client.Port;
   ServerList[ServerTab.Tabs.Count-1].Pass := ServerList[ClickedTab].Pass;
   ServerList[ServerTab.Tabs.Count-1].ServerName := ServerList[ClickedTab].ServerName;
  // ServerList[ServerTab.Tabs.Count-1].AutoRetryTimer := ServerList[ClickedTab].AutoRetryTimer;
  // ServerList[ServerTab.Tabs.Count-1].AutoSay := ServerList[ClickedTab].AutoSay;
  // ServerList[ServerTab.Tabs.Count-1].AutoRetry := ServerList[ClickedTab].AutoRetry;
  // ServerList[ServerTab.Tabs.Count-1].AutoConnect := ServerList[ClickedTab].AutoConnect;
   ServerList[ServerTab.Tabs.Count-1].Timers := ServerList[ClickedTab].Timers;
   ServerList[ServerTab.Tabs.Count-1].TimerName := ServerList[ClickedTab].TimerName;
  // ServerList[ServerTab.Tabs.Count-1].AutoScroll := ServerList[ClickedTab].AutoScroll;

   {
     ServerName: string;
    Teams : array[1..4] of byte;
    MaxPlayer, bots, specs, voting : byte;
    Pass, Maxplayers, bonus, ff, respawn: string;
    AutoRetryTimer: TTimer;
    AutoSay: TTimer;
    AutoRetry, AutoConnect: boolean;
    Config: TConfigSettings;
    Timers: array[0..MAXTIMER] of TARSSETimer;
    TimerName : TStringList;
    AutoScroll, stopparse: Boolean;
  }
  // ServerTab.Tabs[ServerTab.Tabs.Count-1]:= ServerTab.Tabs[ClickedTab];
   //now change to the duplicated tab
  if (Form1.Visible) and (not Ctrl) then
  begin
    ServerTab.TabIndex := i;
    ClickedTab := i;
    ServerTabChange(nil);
  end;
end;

procedure TForm1.ServerTabMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  DraggedTab, PortSwap, i: integer;
  ServerSwap: TServerList;
  TabSwap, HostSwap, PassSwap: string;
begin

  //  TabClicked:= false;
  if (ClickedTab < 0) or (Button = mbRight) or (TabClicked = false) then
    exit;

  if (Button = mbMiddle) then
  begin
    RemoveServerClick(Sender); //close tab
    exit;
  end;
  if X < ServerTab.Left then
    DraggedTab := 0
  else
    DraggedTab := ServerTab.IndexOfTabAt(X, Y);
  if DraggedTab = -1 then
    DraggedTab := ServerTab.Tabs.Count - 1;

  if ClickedTab <> DraggedTab then
  begin
    if ServerName.Visible then
      ServerName.Visible := false;

    ServerSwap := ServerList[ClickedTab];
    TabSwap := ServerTab.Tabs[ClickedTab];
    HostSwap := ServerList[ClickedTab].Client.Host;
    PortSwap := ServerList[ClickedTab].Client.Port;
    PassSwap := ServerList[ClickedTab].Pass;

    if ClickedTab < DraggedTab then
      for i := ClickedTab to DraggedTab - 1 do
      begin

        ServerList[i] := ServerList[i + 1];
        ServerTab.Tabs[i] := ServerTab.Tabs[i + 1];
        ServerList[i].Client.Host := ServerList[i + 1].Client.Host;
        ServerList[i].Client.Port := ServerList[i + 1].Client.Port;
        ServerList[i].Pass := ServerList[i + 1].Pass;

      end
    else if ClickedTab > DraggedTab then
      for i := ClickedTab downto DraggedTab + 1 do
      begin

        ServerList[i] := ServerList[i - 1];
        ServerTab.Tabs[i] := ServerTab.Tabs[i - 1];
        ServerList[i].Client.Host := ServerList[i - 1].Client.Host;
        ServerList[i].Client.Port := ServerList[i - 1].Client.Port;
        ServerList[i].Pass := ServerList[i - 1].Pass;

      end;

    ServerList[DraggedTab] := ServerSwap;
    ServerTab.Tabs[DraggedTab] := TabSwap;
    ServerList[DraggedTab].Client.Host := HostSwap;
    ServerList[DraggedTab].Client.Port := PortSwap;
    ServerList[DraggedTab].Pass := PassSwap;

    ServerTab.TabIndex := DraggedTab;
    {
        ServerSwap:= ServerList[DraggedTab];
        TabSwap:= ServerTab.Tabs[DraggedTab];
        HostSwap:= ServerList[DraggedTab].Client.Host;
        PortSwap:= ServerList[DraggedTab].Client.Port;
        PassSwap:= ServerList[DraggedTab].Pass;

        ServerList[DraggedTab]:= ServerList[ClickedTab];
        ServerTab.Tabs[DraggedTab]:= ServerTab.Tabs[ClickedTab];
        ServerList[DraggedTab].Client.Host:= ServerList[ClickedTab].Client.Host;
        ServerList[DraggedTab].Client.Port:= ServerList[ClickedTab].Client.Port;
        ServerList[DraggedTab].Pass:= ServerList[ClickedTab].Pass;

        ServerList[ClickedTab]:= ServerSwap;
        ServerTab.Tabs[ClickedTab]:= TabSwap;
        ServerList[ClickedTab].Client.Host:= HostSwap;
        ServerList[ClickedTab].Client.Port:= PortSwap;
        ServerList[ClickedTab].Pass:= PassSwap;

        ServerTab.TabIndex:= DraggedTab;
    }

    Form1.Repaint;
  end;

  //  ClickedTab:= -5;
  //  Screen.Cursor:= crDefault;
  TabClicked := false;
  SetFocusToCmd(Form1);
end;

procedure TForm1.Panel2MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  // Screen.Cursor:= crDefault;
  // if (not ServerName.Visible) and (not TabClicked) then ClickedTab:= -2;
  // TabClicked:= false;
end;

procedure TForm1.PassExit(Sender: TObject);
begin
  Pass.PasswordChar := '*';
end;

procedure TForm1.ServerTabEnter(Sender: TObject);
begin
  //if ServerTab.Focused then
   //PlayerList.SetFocus;          //because of deleting tab issues when having focus
  // Cmd.SetFocus;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  if (not PlayerList.Focused) and (PageControl.TabIndex = 0) then
    //don't want to have serverip focused - could be deleted by accident
    if Cmd.Enabled then
      Cmd.SetFocus
    else
      PlayerList.SetFocus;
end;

procedure TForm1.IRCConsoleChange(Sender: TObject);
begin
  if ((Sender as TRichEdit).Lines.Count * 13) < (Sender as TRichEdit).Height
    then
    (Sender as TRichEdit).Perform(WM_VSCROLL, SB_BOTTOM, 0);
end;

procedure TForm1.IRCConsoleKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  IRCConnect.SetFocus;
end;

procedure TForm1.IRCConsoleMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  HideCaret((Sender as TRichEdit).Handle);
  selbegin := (Sender as TRichEdit).SelStart;
  ServerList[ServerTab.TabIndex].stopparse := true; //is this working here too?
end;

procedure TForm1.IRCConsoleMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Clipboard.SetTextBuf(PChar((Sender as TRichEdit).SelText));
  (Sender as TRichEdit).SelLength := 0;
  HideCaret((Sender as TRichEdit).Handle);
  ServerList[ServerTab.TabIndex].stopparse := false; //is this working here too?
  IRCConnect.SetFocus;
end;

procedure TForm1.CmdEnter(Sender: TObject);
begin
  //  cmd.SelStart:= Length(Cmd.Text);
  SelectAll := False;
  if ((cmd.Text = '') or (cmd.Text = '/say ') or (cmd.Text = ' ') or (cmd.Text =
    '/say [' + Config.AdminName + '] ')) then
  begin
    if SayBox.Checked then //are we in chat mode?
    begin
      cmd.Text := '/say ';
      //      PostMessage(cmd.Handle,WM_KEYDOWN,VK_END,0); //remove textselection
    end
    else if NickSayBox.Checked then //are we in nick chat mode?
    begin
      cmd.Text := '/say [' + Config.AdminName + '] ';
    end
    else if AdminBox.Checked then //are we in admin chat mode?
    begin
      cmd.Text := ' ';
      //      PostMessage(cmd.Handle,WM_KEYDOWN,VK_END,0);  //remove textselection
    end;
  end;
  //  else
  PostMessage(cmd.Handle, WM_KEYDOWN, VK_END, 0);
end;

procedure TForm1.PlayerListCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  //set playerlist backgroundcolor
  if Item.SubItems[ITEM_TEAM] = 'Alpha' then
    Sender.Canvas.Brush.Color := $E5E5FF
  else if Item.SubItems[ITEM_TEAM] = 'Bravo' then
    Sender.Canvas.Brush.Color := $FFE9E5
  else if Item.SubItems[ITEM_TEAM] = 'Charlie' then
    Sender.Canvas.Brush.Color := $CCF6FF
  else if Item.SubItems[ITEM_TEAM] = 'Delta' then
    Sender.Canvas.Brush.Color := $D1FFCC
  else if Item.SubItems[ITEM_TEAM] = 'Spectator' then
    Sender.Canvas.Brush.Color := $FFE5F6
  else if Item.SubItems[ITEM_TEAM] = 'None' then
    Sender.Canvas.Brush.Color := clWhite;
  Sender.Canvas.Font.Color := clBtnText;
end;

procedure TForm1.AdminBoxClick(Sender: TObject);
var
  S: string;
begin
  if AdminBox.Checked then
  begin
    SayBox.Checked := false;
    NickSayBox.Checked := false;
  end;

  Cmd.SetFocus;

  if AdminBox.Checked then
  begin
    if Matches(' *', Cmd.Text) then
    begin
      S := Cmd.Text;
      Delete(S, 1, 1);
      Cmd.Text := S;
    end;
    if Matches('/say [' + Config.AdminName + '] *', Cmd.Text) then
    begin
      S := Cmd.Text;
      Delete(S, 1, 5 + 3 + Length(Config.AdminName));
      Cmd.Text := S;
    end
    else if Matches('/say *', Cmd.Text) then
    begin
      S := Cmd.Text;
      Delete(S, 1, 5);
      Cmd.Text := S;
    end;
    if not Matches(' *', Cmd.Text) then
      Cmd.Text := ' ' + Cmd.Text;

    Cmd.SelStart := Length(Cmd.Text);
  end
  else
  begin
    if Matches(' *', Cmd.Text) then
    begin
      S := Cmd.Text;
      Delete(S, 1, 1);
      Cmd.Text := S;
    end;
    if Matches('/say [' + Config.AdminName + '] *', Cmd.Text) then
    begin
      S := Cmd.Text;
      Delete(S, 1, 5 + 3 + Length(Config.AdminName));
      Cmd.Text := S;
    end
    else if Matches('/say *', Cmd.Text) then
    begin
      S := Cmd.Text;
      Delete(S, 1, 5);
      Cmd.Text := S;
    end;
    Cmd.SelStart := Length(Cmd.Text);
  end;

end;

procedure TForm1.SayBoxClick(Sender: TObject);
var
  S: string;
begin
  if SayBox.Checked then
  begin
    AdminBox.Checked := false;
    NickSayBox.Checked := false;
  end;

  Cmd.SetFocus;

  if SayBox.Checked then
  begin
    if Matches(' *', Cmd.Text) then
    begin
      S := Cmd.Text;
      Delete(S, 1, 1);
      Cmd.Text := S;
    end;
    if Matches('/say [' + Config.AdminName + '] *', Cmd.Text) then
    begin
      S := Cmd.Text;
      Delete(S, 1, 5 + 3 + Length(Config.AdminName));
      Cmd.Text := '/say ' + S;
    end
    else if not Matches('/say *', Cmd.Text) then
      Cmd.Text := '/say ' + Cmd.Text;

    Cmd.SelStart := Length(Cmd.Text);
  end
  else
  begin
    if Matches(' *', Cmd.Text) then
    begin
      S := Cmd.Text;
      Delete(S, 1, 1);
      Cmd.Text := S;
    end;
    if Matches('/say [' + Config.AdminName + '] *', Cmd.Text) then
    begin
      S := Cmd.Text;
      Delete(S, 1, 5 + 3 + Length(Config.AdminName));
      Cmd.Text := S;
    end
    else if Matches('/say *', Cmd.Text) then
    begin
      S := Cmd.Text;
      Delete(S, 1, 5);
      Cmd.Text := S;
    end;
    Cmd.SelStart := Length(Cmd.Text);
  end;

end;

procedure TForm1.NickSayBoxClick(Sender: TObject);
var
  S: string;
begin
  if NickSayBox.Checked then
  begin
    AdminBox.Checked := false;
    SayBox.Checked := false;
  end;

  Cmd.SetFocus;

  if NickSayBox.Checked then
  begin
    if Matches(' *', Cmd.Text) then
    begin
      S := Cmd.Text;
      Delete(S, 1, 1);
      Cmd.Text := S;
    end;
    if (Matches('/say *', Cmd.Text)) and
      (not Matches('/say [' + Config.AdminName + '] *', Cmd.Text)) then
    begin
      S := Cmd.Text;
      Delete(S, 1, 5);
      Cmd.Text := '/say [' + Config.AdminName + '] ' + S;
    end
    else if not Matches('/say [' + Config.AdminName + '] *', Cmd.Text) then
    begin
      Cmd.Text := '/say [' + Config.AdminName + '] ' + Cmd.Text;
    end;
    Cmd.SelStart := Length(Cmd.Text);
  end
  else
  begin
    if Matches(' *', Cmd.Text) then
    begin
      S := Cmd.Text;
      Delete(S, 1, 1);
      Cmd.Text := S;
    end;
    if Matches('/say [' + Config.AdminName + '] *', Cmd.Text) then
    begin
      S := Cmd.Text;
      Delete(S, 1, 5 + 3 + Length(Config.AdminName));
      Cmd.Text := S;
    end
    else if Matches('/say *', Cmd.Text) then
    begin
      S := Cmd.Text;
      Delete(S, 1, 5);
      Cmd.Text := S;
    end;
    Cmd.SelStart := Length(Cmd.Text);
  end;

end;

procedure TForm1.SetFocusToCmd(Sender: TObject);
begin
  // causes clicking issues
  {if PlayerList.Focused or ActionList.Focused then
    exit;
  if not Form1.Visible then
    exit;
  if PageControl.ActivePage = ServerConsole then
    if Cmd.Enabled then
      Cmd.SetFocus
    else
      PlayerList.SetFocus
  else if PageControl.ActivePage = BotConsole then
    if IRCCmd.Enabled then
      IRCCmd.SetFocus
    else
      UserBox.SetFocus;}
end;

procedure TForm1.IP30days1Click(Sender: TObject);
var
  i: integer;
  S: string;
  ch: char;
begin
  if PlayerList.Items.Count = 0 then
    exit;
  i := PlayerList.Itemindex;
  if (i < 0) or (i > (PlayerList.Items.Count - 1)) then
    exit;

  S := PlayerList.Items[i].Caption;

  Cmd.Text := '/ban ' + S;
  ch := #13;
  CmdKeyPress(nil, ch);
end;

procedure TForm1.SpeedButtonClick(Sender: TObject);
begin
  ConnectPopup.Popup(Form1.Left + Connect.Left + 25, Form1.Top + Connect.Top +
    Connect.Height + GroupBox2.Top +
    AddFavServ.Height + 28);
end;

procedure TForm1.ActionViewAddition(Sender: TObject; Node: TTreeNode);
begin
  Node.Expanded := true;
end;

procedure TForm1.ActionViewAdvancedCustomDrawItem(Sender: TCustomTreeView;
  Node: TTreeNode; State: TCustomDrawState; Stage: TCustomDrawStage;
  var PaintImages, DefaultDraw: Boolean);
begin
  DefaultDraw := false;
  Sender.Canvas.FillRect(Node.DisplayRect(false));
  if Node.HasChildren then
  begin
    Sender.Canvas.Font.Style := [fsBold];
    Sender.Canvas.TextOut(Node.DisplayRect(false).Left + 2,
      Node.DisplayRect(false).top, Node.Text);
  end
  else
  begin
    Sender.Canvas.Font.Style := [];
    Sender.Canvas.TextOut(Node.DisplayRect(false).Left + 5,
      Node.DisplayRect(false).top, Node.Text);
  end;
end;

// detects if it should show tooltip for flag since they can move
procedure TForm1.PlayerListInfoTip(Sender: TObject; Item: TListItem;
  var InfoTip: string);
var
  pt: TPoint;
  flagId, w, i: integer;
begin
  w := -GetScrollPos((Sender as TListView).Handle, SB_HORZ);

  for i := COLUMN_ID to COLUMN_NUM do
  begin
    if (Sender as TListView).Column[i].Tag = COLUMN_NAME then
      break
    else if columnsVisibility[(Sender as TListView).Column[i].Tag] = true then
      w := w + (Sender as TListView).Column[i].Width;
  end;

  pt := (Sender as TListView).ScreenToClient(Mouse.CursorPos);
  pt.x := pt.x - w - 2;
  flagId := ServerList[ServerTab.TabIndex].playerFlag[StrToInt(Item.Caption)];

  if (pt.x >= 0) and (pt.x < CountryFlags[flagid].Width) then
    InfoTip := CountryNames[flagid]
  else
    InfoTip := '';
end;

// bantag kick
procedure TForm1.HWID1Click(Sender: TObject);
var
  i: integer;
  S: string;
  ch: char;
begin
  if PlayerList.Items.Count = 0 then
    exit;
  i := PlayerList.Itemindex;
  if (i < 0) or (i > (PlayerList.Items.Count - 1)) then
    exit;

  S := PlayerList.Items[i].SubItems[ITEM_HWID];

  if S = '' then
    exit;

  Cmd.Text := '/banhw ' + S;
  ch := #13;
  CmdKeyPress(nil, ch);
  Kick1Click(Sender);
end;

procedure TForm1.PlayerTagID1Click(Sender: TObject);
begin
  Clipboard.SetTextBuf(PChar(PlayerList.Items[PlayerList.Itemindex].Subitems[ITEM_HWID]));
end;

// for hiding empty columns on older refreshx
procedure TForm1.SetPlayerListColumnWidthAndMinwidth(column: Integer; show: Boolean);
var
  width, minWidth, currentWidth, i: integer;
begin
  // only update when necessary
  if show = columnsVisibility[column] then
    exit;

  columnsVisibility[column] := show;

  if show then
  begin
    width := columnsWidth[column];
    minWidth := columnsMinWidth[column];
  end
  else
  begin
    width := 0;
    minWidth := 0;
  end;

  currentWidth := columnsWidth[column];

  // is column on default position?
  if PlayerList.Column[column].Tag = column then
  begin
    currentWidth := PlayerList.Columns[column].Width;
      PlayerList.Columns[column].MinWidth := minWidth;
      PlayerList.Columns[column].Width := width;
  end
  else  // find the correct column position
    for i := 0 to COLUMN_NUM do
      if PlayerList.Column[i].Tag = column then
      begin
        currentWidth := PlayerList.Columns[i].Width;
          PlayerList.Columns[i].MinWidth := minWidth;
          PlayerList.Columns[i].Width := width;
        break;
      end;

  if (not show) and (currentWidth <> 0) then
    columnsWidth[column] := currentWidth;
end;

procedure TForm1.ApplicationEvents1Activate(Sender: TObject);
begin
  with ServerList[ServerTab.TabIndex].Memo do
  if Cmd.Focused then
  begin
    Cmd.SelStart := Length(Cmd.Text);
  end
  else if Host.Focused then
  begin
    Host.SelStart := Length(Host.Text);
  end
  else if Focused then
  begin
    if Cmd.Enabled then
      Cmd.SetFocus
    else
      PlayerList.SetFocus;
  end;
end;

procedure TForm1.ApplicationEvents1Deactivate(Sender: TObject);
var
 line: integer;
begin
  with ServerList[ServerTab.TabIndex].Memo do
  begin
    if not SearchForm1.Visible then
    begin
      line := Perform(EM_GETFIRSTVISIBLELINE, 0, 0);
      SelStart := Perform(EM_LINEINDEX, line+3, 0);
      SelLength := 0;
    end;
  end;
end;

end.

