unit pu_chart;

{$MODE Delphi}{$H+}

{
Copyright (C) 2002 Patrick Chevalley

http://www.astrosurf.com/astropc
pch@freesurf.ch

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
}
{
 Chart child form 
}
//{$define showtime}

{ TODO : look if we still need otherwise, (with moveable label)  }
{$define ImageBuffered}

interface

uses
     pu_ascomclient, pu_lx200client, pu_encoderclient, pu_indiclient, pu_getdss,
     u_translation, pu_detail, cu_skychart,  u_constant, u_util,pu_image,
     u_projection, Printers, Math, downloaddialog, IntfGraphics,
     PostscriptCanvas, FileUtil, Clipbrd, LCLIntf, Classes, Graphics, Dialogs, Types,
     Forms, Controls, StdCtrls, ExtCtrls, Menus, ActnList, SysUtils, LResources;
     
const maxundo=10;

type
  Tstr1func = procedure(txt:string) of object;
  Tstr12func = procedure(txt1,txt2:string) of object;
  Tstr2func = procedure(txt:string;sender:TObject) of object;
  Tint2func = procedure(i1,i2:integer) of object;
  Tbtnfunc = procedure(i1,i2:integer;b1:boolean;sender:TObject) of object;
  Tshowinfo = procedure(txt:string; origin:string='';sendmsg:boolean=false; Sender: TObject=nil; txt2:string='') of object;

type
  TChartDrawingControl = class(TCustomControl)
  public
    procedure Paint; override;
    property onMouseDown;
    property onMouseMove;
    property onMouseUp;
  end;
  
  { Tf_chart }
  Tf_chart = class(TForm)
    About2: TMenuItem;
    About1: TMenuItem;
    AddLabel1: TMenuItem;
    DownloadDialog1: TDownloadDialog;
    CopyCoord1: TMenuItem;
    Cleanupmap1: TMenuItem;
    MenuFinderCircle: TMenuItem;
    nsearch1: TMenuItem;
    nsearch2: TMenuItem;
    nsearch3: TMenuItem;
    SearchName1: TMenuItem;
    SearchMenu1: TMenuItem;
    search1: TMenuItem;
    search2: TMenuItem;
    search3: TMenuItem;
    Target1: TMenuItem;
    MenuSaveCircle: TMenuItem;
    MenuLoadCircle: TMenuItem;
    MenuLabel: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    SlewCursor: TMenuItem;
    PDSSTimer: TTimer;
    TrackTelescope: TMenuItem;
    Panel1: TPanel;
    RemoveLastLabel1: TMenuItem;
    RemoveAllLabel1: TMenuItem;
    RefreshTimer: TTimer;
    ActionList1: TActionList;
    BlinkTimer: TTimer;
    VertScrollBar: TScrollBar;
    HorScrollBar: TScrollBar;
    zoomplus: TAction;
    zoomminus: TAction;
    MoveWest: TAction;
    MoveEast: TAction;
    MoveNorth: TAction;
    MoveSouth: TAction;
    MoveNorthWest: TAction;
    MoveNorthEast: TAction;
    MoveSouthWest: TAction;
    MoveSouthEast: TAction;
    Centre: TAction;
    PopupMenu1: TPopupMenu;
    Zoom1: TMenuItem;
    Zoom2: TMenuItem;
    Centre1: TMenuItem;
    zoomplusmove: TAction;
    zoomminusmove: TAction;
    FlipX: TAction;
    FlipY: TAction;
    Undo: TAction;
    Redo: TAction;
    rot_plus: TAction;
    rot_minus: TAction;
    GridEQ: TAction;
    Grid: TAction;
    identlabel: TLabel;
    switchbackground: TAction;
    switchstar: TAction;
    Telescope1: TMenuItem;
    Connect1: TMenuItem;
    Slew1: TMenuItem;
    Sync1: TMenuItem;
    NewFinderCircle1: TMenuItem;
    N1: TMenuItem;
    RemoveLastCircle1: TMenuItem;
    RemoveAllCircles1: TMenuItem;
    AbortSlew1: TMenuItem;
    TelescopeTimer: TTimer;
    N3: TMenuItem;
    TrackOn1: TMenuItem;
    TrackOff1: TMenuItem;
    procedure About1Click(Sender: TObject);
    procedure AddLabel1Click(Sender: TObject);
    procedure BlinkTimerTimer(Sender: TObject);
    procedure Cleanupmap1Click(Sender: TObject);
    procedure CopyCoord1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ChartResize(Sender: TObject);
    procedure HorScrollBarChange(Sender: TObject);
    procedure HorScrollBarScroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure MenuLoadCircleClick(Sender: TObject);
    procedure MenuSaveCircleClick(Sender: TObject);
    procedure nsearch1Click(Sender: TObject);
    procedure PDSSTimerTimer(Sender: TObject);
    procedure RefreshTimerTimer(Sender: TObject);
    procedure RemoveAllLabel1Click(Sender: TObject);
    procedure RemoveLastLabel1Click(Sender: TObject);
    procedure search1Click(Sender: TObject);
    procedure SlewCursorClick(Sender: TObject);
    procedure Target1Click(Sender: TObject);
    procedure TrackTelescopeClick(Sender: TObject);
    procedure VertScrollBarChange(Sender: TObject);
    procedure VertScrollBarScroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure zoomplusExecute(Sender: TObject);
    procedure zoomminusExecute(Sender: TObject);
    procedure MoveWestExecute(Sender: TObject);
    procedure MoveEastExecute(Sender: TObject);
    procedure MoveNorthExecute(Sender: TObject);
    procedure MoveSouthExecute(Sender: TObject);
    procedure MoveNorthWestExecute(Sender: TObject);
    procedure MoveNorthEastExecute(Sender: TObject);
    procedure MoveSouthWestExecute(Sender: TObject);
    procedure MoveSouthEastExecute(Sender: TObject);
    procedure CentreExecute(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure zoomminusmoveExecute(Sender: TObject);
    procedure zoomplusmoveExecute(Sender: TObject);
    procedure FlipXExecute(Sender: TObject);
    procedure FlipYExecute(Sender: TObject);
    procedure UndoExecute(Sender: TObject);
    procedure RedoExecute(Sender: TObject);
    procedure rot_plusExecute(Sender: TObject);
    procedure rot_minusExecute(Sender: TObject);
    procedure GridEQExecute(Sender: TObject);
    procedure GridExecute(Sender: TObject);
    procedure identlabelClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure switchstarExecute(Sender: TObject);
    procedure switchbackgroundExecute(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Connect1Click(Sender: TObject);
    procedure Slew1Click(Sender: TObject);
    procedure Sync1Click(Sender: TObject);
    procedure NewFinderCircle1Click(Sender: TObject);
    procedure RemoveLastCircle1Click(Sender: TObject);
    procedure RemoveAllCircles1Click(Sender: TObject);
    procedure AbortSlew1Click(Sender: TObject);
    procedure TelescopeTimerTimer(Sender: TObject);
    procedure TrackOn1Click(Sender: TObject);
    procedure TrackOff1Click(Sender: TObject);
  private
    { Private declarations }
    FImageSetFocus: TnotifyEvent;
    FSetFocus: TnotifyEvent;
    FShowTopMessage: Tstr2func;
    FShowTitleMessage: Tstr2func;
    FUpdateBtn: Tbtnfunc;
    FShowInfo : Tshowinfo;
    FShowCoord: Tstr1func;
    FListInfo: Tstr12func;
    FChartMove: TnotifyEvent;
    movefactor,zoomfactor: double;
    xcursor,ycursor,skipmove,movecamnum,moveguidetype,moveguidenum : integer;
    MovingCircle,FNightVision,StartCircle,lockkey,movecam,moveguide,frommovecam,printing: Boolean;
    SaveColor: Starcolarray;
    SaveLabelColor: array[1..numlabtype] of Tcolor;
    PrintPreview: Tf_image;
    Fpop_indi: Tpop_indi;
    Fpop_encoder: Tpop_encoder;
    Fpop_lx200: Tpop_lx200;
    Fpop_scope: Tpop_scope;
    procedure ConnectINDI(Sender: TObject);
    procedure SlewINDI(Sender: TObject);
    procedure SyncINDI(Sender: TObject);
    procedure AbortSlewINDI(Sender: TObject);
    procedure ConnectASCOM(Sender: TObject);
    procedure SlewASCOM(Sender: TObject);
    procedure SyncASCOM(Sender: TObject);
    procedure AbortSlewASCOM(Sender: TObject);
    procedure ConnectLX200(Sender: TObject);
    procedure SlewLX200(Sender: TObject);
    procedure SyncLX200(Sender: TObject);
    procedure AbortSlewLX200(Sender: TObject);
    procedure ConnectEncoder(Sender: TObject);
    procedure SyncEncoder(Sender: TObject);
    procedure SetNightVision(value:boolean);
    procedure Image1Click(Sender: TObject);
    procedure Image1DblClick(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure Image1Paint(Sender: TObject);
    procedure SetScrollBar;
    procedure ShowCoord(x,y: Integer);
  public
    { Public declarations }
    Image1 : TChartDrawingControl;
    ChartCursor: TCursor;
    sc: Tskychart;
    cmain: Tconf_main;
    locked,LockTrackCursor,LockKeyboard,lastquick,lock_refresh,lockscrollbar,TrackCursorMove,lockmove,MeasureOn :boolean;
    undolist : array[1..maxundo] of Tconf_skychart;
    lastundo,curundo,validundo, lastx,lasty,lastyzoom  : integer;
    lastl,lastb,MeasureRa,MeasureDe: double;
    zoomstep,Xzoom1,Yzoom1,Xzoom2,Yzoom2,DXzoom,DYzoom,XZoomD1,YZoomD1,XZoomD2,YZoomD2,ZoomMove : integer;
    XM1,YM1,XMD1,YMD1: integer;
    procedure Refresh;
    procedure AutoRefresh;
    procedure PrintChart(printlandscape:boolean; printcolor,printmethod,printresol:integer ;printcmd1,printcmd2,printpath:string; cm:Tconf_main; preview:boolean);
    function  FormatDesc:string;
    procedure ShowIdentLabel;
    function  IdentXY(X, Y: Integer;searchcenter: boolean= true; showlabel: boolean= true):boolean;
    procedure Identdetail(X, Y: Integer);
    function  ListXY(X, Y: Integer):boolean;
    procedure CKeyDown(var Key: Word; Shift: TShiftState);
    procedure rotation(rot:double);
    procedure GetSunImage;
    function cmd_SetCursorPosition(x,y:integer):string;
    function cmd_SetGridEQ(onoff:string):string;
    function cmd_SetGrid(onoff:string):string;
    function cmd_SetStarMode(i:integer):string;
    function cmd_SetNebMode(i:integer):string;
    function cmd_SetSkyMode(onoff:string):string;
    function cmd_SetProjection(proj:string):string;
    function cmd_SetFov(fov:string):string;
    function cmd_Resize(w,h:string):string;
    function cmd_SetRa(param1:string):string;
    function cmd_SetDec(param1:string):string;
    function cmd_SetDate(dt:string):string;
    function cmd_SetObs(obs:string):string;
    function cmd_IdentCursor:string;
    function cmd_SaveImage(format,fn,quality:string):string;
    function cmd_Print(Method,Orient,Col,path:string):string;
    function ExecuteCmd(arg:Tstringlist):string;
    function SaveChartImage(format,fn : string; quality: integer=95):boolean;
    Procedure ZoomBox(action,x,y:integer);
    Procedure MeasureDistance(action,x,y:integer);
    Procedure TrackCursor(X,Y : integer);
    Procedure ZoomCursor(yy : double);
    procedure SetField(field : double);
    procedure SetZenit(field : double; redraw:boolean=true);
    procedure SetAz(Az : double; redraw:boolean=true);
    procedure SetDateUT(y,m,d,h,n,s:integer);
    procedure SetJD(njd:double);
    procedure SwitchCompass(Sender: TObject);
    function cmd_GetProjection:string;
    function cmd_GetSkyMode:string;
    function cmd_GetNebMode:string;
    function cmd_GetStarMode:string;
    function cmd_GetGrid:string;
    function cmd_GetGridEQ:string;
    function cmd_GetCursorPosition :string;
    function cmd_GetFov(format:string):string;
    function cmd_GetRA(format:string):string;
    function cmd_GetDEC(format:string):string;
    function cmd_GetDate:string;
    function cmd_GetObs:string;
    function cmd_SetTZ(tz:string):string;
    function cmd_GetTZ:string;
    function cmd_PDSS(DssDir,ImagePath,ImageName, useexisting: string):string;
    procedure cmd_GoXY(xx,yy : string);
    function cmd_IdXY(xx,yy : string): string;
    procedure cmd_MoreStar;
    procedure cmd_LessStar;
    procedure cmd_MoreNeb;
    procedure cmd_LessNeb;
    function cmd_SetGridNum(onoff:string):string;
    function cmd_SetConstL(onoff:string):string;
    function cmd_SetConstB(onoff:string):string;
    function cmd_SwitchGridNum:string;
    function cmd_SwitchConstL:string;
    function cmd_SwitchConstB:string;
    procedure SetLang;
    procedure ChartActivate;
    procedure SetCameraRotation(cam:integer);
    procedure MoveCamera(angle:single);
    property OnImageSetFocus: TNotifyEvent read FImageSetFocus write FImageSetFocus;
    property OnSetFocus: TNotifyEvent read FSetFocus write FSetFocus;
    property OnShowTopMessage: Tstr2func read FShowTopMessage write FShowTopMessage;
    property OnShowTitleMessage: Tstr2func read FShowTitleMessage write FShowTitleMessage;
    property OnUpdateBtn: Tbtnfunc read FUpdateBtn write FUpdateBtn;
    property OnShowInfo: TShowinfo read FShowInfo write FShowInfo;
    property OnShowCoord: Tstr1func read FShowCoord write FShowCoord;
    property OnListInfo: Tstr12func read FListInfo write FListInfo;
    property OnChartMove: TNotifyEvent read FChartMove write FChartMove;
    property NightVision: Boolean read FNightVision write SetNightVision;
  end;

implementation
{$R *.lfm}

procedure Tf_chart.SetLang;
begin
About1.caption:=rsAbout;
Centre1.caption:=rsCentre;
Zoom1.caption:=rsZoomCentre;
Zoom2.caption:=rsZoomCentre2;
MenuFinderCircle.Caption:=rsFinderCircle2;
NewFinderCircle1.caption:=rsNewFinderCir;
RemoveLastCircle1.caption:=rsRemoveLastCi;
RemoveAllCircles1.caption:=rsRemoveAllCir;
MenuSaveCircle.Caption:=rsSaveToFile;
MenuLoadCircle.Caption:=rsLoadFromFile;
MenuLabel.Caption:=rsLabels;
AddLabel1.caption:=rsNewLabel;
RemoveLastLabel1.caption:=rsRemoveLastLa;
RemoveAllLabel1.caption:=rsRemoveAllLab;
SearchName1.Caption:=rsSearchByName;
nsearch1.Caption:=infoname_url[1,2];
nsearch2.Caption:=infoname_url[2,2];
nsearch3.Caption:=infoname_url[3,2];
SearchMenu1.Caption:=rsSearchByPosi;
search1.Caption:=infocoord_url[1,2];
search2.Caption:=infocoord_url[2,2];
search3.Caption:=infocoord_url[3,2];
Telescope1.caption:=rsTelescope;
TrackTelescope.Caption:=rsTrackTelesco;
SlewCursor.Caption:=rsSlewToCursor;
Slew1.caption:=rsSlew;
Sync1.caption:=rsSync;
CopyCoord1.Caption:=rsCopyCoordina;
Cleanupmap1.Caption:=rsCleanupMap;
Connect1.caption:=rsConnectTeles;
AbortSlew1.caption:=rsAbortSlew;
TrackOff1.caption:=rsUnlockChart;
DownloadDialog1.msgDownloadFile:=rsDownloadFile;
DownloadDialog1.msgCopyfrom:=rsCopyFrom;
DownloadDialog1.msgtofile:=rsToFile;
DownloadDialog1.msgDownloadBtn:=rsDownload;
DownloadDialog1.msgCancelBtn:=rsCancel;
if sc<>nil then sc.SetLang;
if Fpop_lx200<>nil then Fpop_lx200.SetLang;
if Fpop_encoder<>nil then Fpop_encoder.SetLang;
if Fpop_indi<>nil then Fpop_indi.SetLang;
if Fpop_scope<>nil then Fpop_scope.SetLang;
end;

procedure Tf_chart.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  RefreshTimer.Enabled:=false;
  TelescopeTimer.Enabled:=false;
  Action := caFree;
end;

procedure Tf_chart.FormCreate(Sender: TObject);
var i: integer;
begin
{$ifdef trace_debug}
 WriteTrace('Create new chart');
{$endif}
 locked:=true;
 lockmove:=false;
 lockkey:=false;
 movecam:=false;
 moveguide:=false;
 frommovecam:=false;
 printing:=false;
 MeasureOn:=false;
 SetLang;
 for i:=1 to maxundo do undolist[i]:=Tconf_skychart.Create;
 Image1:= TChartDrawingControl.Create(Self);
 Image1.Parent := Panel1;
 IdentLabel.Parent:=Image1;
 Image1.Align:=alClient;
 Image1.DoubleBuffered := true;
 Image1.OnClick:=Image1Click;
 image1.OnDblClick:=Image1DblClick;
 Image1.OnMouseDown:=Image1MouseDown;
 Image1.OnMouseMove:=Image1MouseMove;
 Image1.OnMouseUp:=Image1MouseUp;
 Image1.OnMouseWheel:=Image1MouseWheel;
 Image1.OnPaint:=Image1Paint;
 Image1.PopupMenu:=PopupMenu1;
 sc:=Tskychart.Create(Image1);
 sc.Image:=Image1.Canvas;
 // set initial value
 sc.cfgsc.racentre:=1.4;
 sc.cfgsc.decentre:=0;
 sc.cfgsc.fov:=1;
 sc.cfgsc.theta:=0;
 sc.cfgsc.projtype:='A';
 sc.cfgsc.ProjPole:=Equat;
 sc.cfgsc.FlipX:=1;
 sc.cfgsc.FlipY:=1;
 sc.onShowDetailXY:=IdentDetail;
 sc.InitChart(false);
 skipmove:=0;
 movefactor:=4;
 zoomfactor:=2;
 lastundo:=0;
 validundo:=0;
 LockKeyboard:=false;
 LockTrackCursor:=false;
 ChartCursor:=crRetic;
 Image1.Cursor := ChartCursor;
 lock_refresh:=false;
 MovingCircle:=false;
{$ifdef lclgtk2}  // clic on bar or arrow not working
 HorScrollBar.onChange:=HorScrollBarChange;
 VertScrollBar.onChange:=VertScrollBarChange;
{$else}
 HorScrollBar.onScroll:=HorScrollBarScroll;
 VertScrollBar.onScroll:=VertScrollBarScroll;
{$endif}
 VertScrollBar.Max:=90*3600;   // arcsecond position precision
 VertScrollBar.Min:=-90*3600;
 VertScrollBar.SmallChange:=3600;
 VertScrollBar.LargeChange:=8*VertScrollBar.SmallChange;
 VertScrollBar.PageSize:=VertScrollBar.LargeChange;
 VertScrollBar.Width:=HorScrollBar.Height;
 HorScrollBar.Max:=360*3600;
 HorScrollBar.Min:=0;
 HorScrollBar.SmallChange:=3600;
 HorScrollBar.LargeChange:=8*HorScrollBar.SmallChange;
 HorScrollBar.PageSize:=HorScrollBar.LargeChange;
end;

procedure Tf_chart.FormDestroy(Sender: TObject);
var i: integer;
    ok:boolean;
begin
{$ifdef trace_debug}
 WriteTrace('Destroy chart '+sc.cfgsc.chartname);
{$endif}
try
 locked:=true;
 if sc<>nil then sc.free;
 Image1.Free;
 if Fpop_indi<>nil then begin
   if Connect1.Checked then begin
     Fpop_indi.ScopeDisconnect(ok);
     Application.ProcessMessages;
     sleep(500);
   end;
   Fpop_indi.Free;
 end;
 if Fpop_lx200<>nil then begin
   if Connect1.Checked then Fpop_lx200.ScopeDisconnect(ok);
   Fpop_lx200.Free;
 end;
 if Fpop_encoder<>nil then begin
   if Connect1.Checked then Fpop_encoder.ScopeDisconnect(ok);
   Fpop_encoder.Free;
 end;
 for i:=1 to maxundo do undolist[i].Free;
 {$ifdef trace_debug}
  WriteTrace('End Destroy chart ');
 {$endif}
except
writetrace('error destroy '+name);
end;
end;

procedure Tf_chart.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
CKeyDown(Key,Shift);
end;

procedure Tf_chart.Image1Click(Sender: TObject);
begin
{$ifdef trace_debug}
 WriteTrace(caption+' Image1Click');
{$endif}
// to restore focus to the chart that as no text control
if assigned(FSetFocus) then FSetFocus(Self);
if assigned(FImageSetFocus) then FImageSetFocus(Sender);
//setfocus;
end;

procedure Tf_chart.Image1DblClick(Sender: TObject);
begin
{$ifdef trace_debug}
 WriteTrace(caption+' Image1DblClick');
{$endif}
if identlabel.Visible then identlabelClick(sender);
end;

procedure Tf_chart.GetSunImage;
var fn:string;
begin
fn:=slash(TempDir)+'sun.jpg';
if sc.cfgsc.SunOnline and (
   ( not FileExists(fn) ) or
   ( (now-FileDateToDateTime(FileAge(fn)))>(sc.cfgsc.sunrefreshtime/24) )
   ) then begin
     if cmain.HttpProxy then begin
        DownloadDialog1.SocksProxy:='';
        DownloadDialog1.SocksType:='';
        DownloadDialog1.HttpProxy:=cmain.ProxyHost;
        DownloadDialog1.HttpProxyPort:=cmain.ProxyPort;
        DownloadDialog1.HttpProxyUser:=cmain.ProxyUser;
        DownloadDialog1.HttpProxyPass:=cmain.ProxyPass;
     end else if cmain.SocksProxy then begin
        DownloadDialog1.HttpProxy:='';
        DownloadDialog1.SocksType:=cmain.SocksType;
        DownloadDialog1.SocksProxy:=cmain.ProxyHost;
        DownloadDialog1.HttpProxyPort:=cmain.ProxyPort;
        DownloadDialog1.HttpProxyUser:=cmain.ProxyUser;
        DownloadDialog1.HttpProxyPass:=cmain.ProxyPass;
     end else begin
        DownloadDialog1.SocksProxy:='';
        DownloadDialog1.SocksType:='';
        DownloadDialog1.HttpProxy:='';
        DownloadDialog1.HttpProxyPort:='';
        DownloadDialog1.HttpProxyUser:='';
        DownloadDialog1.HttpProxyPass:='';
     end;
   DownloadDialog1.URL:=sc.cfgsc.sunurl;
   DownloadDialog1.SaveToFile:=fn;
   DownloadDialog1.ConfirmDownload:=false;
   if DownloadDialog1.Execute and FileExists(fn) then begin

   end
   else begin
     sc.cfgsc.SunOnline:=false;
   end;
end;
end;

procedure Tf_chart.AutoRefresh;
begin
if locked then exit;
{$ifdef trace_debug}
 WriteTrace(caption+' AutoRefresh');
{$endif}
if (not sc.cfgsc.TrackOn)and(sc.cfgsc.Projpole=Altaz) then begin
  sc.cfgsc.TrackOn:=true;
  sc.cfgsc.TrackType:=4;
end;
Refresh;
end;

procedure Tf_chart.Refresh;
var  savebg:Tcolor;
     i: integer;
{$ifdef showtime}
     starttime:TDateTime;
{$endif}
begin
if printing then exit;
{$ifdef trace_debug}
 WriteTrace('Chart '+sc.cfgsc.chartname+': Refresh');
{$endif}
{$ifdef showtime}
starttime:=now;
{$endif}
if locked then exit;
if lock_refresh then exit;
try
{$ifdef trace_debug}
 WriteTrace('Chart '+sc.cfgsc.chartname+': Get refresh lock');
{$endif}
 lock_refresh:=true;
 lastquick:=sc.cfgsc.quick;
 zoomstep:=0;
 if (not frommovecam)and(movecam or moveguide) then begin
   movecam:=false;
   moveguide:=false;
   for i:=1 to 10 do sc.cfgsc.circle[i,4]:=0;
   for i:=1 to 10 do sc.cfgsc.rectangle[i,5]:=0;
 end;
 frommovecam:=false;
 identlabel.visible:=false;
 Image1.width:=clientwidth;
 Image1.height:=clientheight;
{$ifdef trace_debug}
 WriteTrace('Chart '+sc.cfgsc.chartname+': Init '+inttostr(Image1.width)+'x'+inttostr(Image1.height));
{$endif}
 sc.plot.init(Image1.width,Image1.height);
 savebg:=sc.plot.cfgplot.color[0];
 if (sc.plot.cfgplot.color[0]<clWhite) and
    not(sc.plot.cfgplot.AutoSkyColor and (sc.cfgsc.Projpole=AltAz)) then
    sc.plot.cfgplot.bgcolor:=sc.plot.cfgplot.skycolor[0];
{$ifdef trace_debug}
 WriteTrace('Chart '+sc.cfgsc.chartname+': Draw map');
{$endif}
 if sc.plot.cfgplot.plaplot=2 then GetSunImage;
 sc.Refresh;
{$ifdef trace_debug}
 WriteTrace('Chart '+sc.cfgsc.chartname+': Draw map end');
{$endif}
 sc.plot.cfgplot.color[0]:=savebg;
 Image1.Invalidate;
 if not lastquick then begin
    inc(lastundo); inc(validundo);
    if lastundo>maxundo then lastundo:=1;
    undolist[lastundo].Assign(sc.cfgsc);
    curundo:=lastundo;
    Identlabel.color:=sc.plot.cfgplot.color[0];
    Identlabel.font.color:=sc.plot.cfgplot.color[11];
    if sc.cfgsc.FindOk then ShowIdentLabel;
    if assigned(FShowTopMessage) then FShowTopMessage(sc.GetChartInfo,self);
    if assigned(FShowTitleMessage) then FShowTitleMessage(sc.GetChartPos,self);
    Image1.Cursor:=ChartCursor;
end;
finally
{$ifdef trace_debug}
 WriteTrace('Chart '+sc.cfgsc.chartname+': Release refresh lock');
{$endif}
 lock_refresh:=false;
 if (not lastquick) and assigned(FUpdateBtn) then FUpdateBtn(sc.cfgsc.flipx,sc.cfgsc.flipy,Connect1.checked,self);
 if (not lastquick) and sc.cfgsc.moved and assigned(FChartMove) then FChartMove(self);
end;
if assigned(FImageSetFocus) then FImageSetFocus(Self);
if assigned(Fshowinfo) then begin
  {$ifdef showtime}
   Fshowinfo('Drawing time: '+formatfloat(f2,(now-starttime)*86400));
  {$else}
  if sc.cfgsc.TrackOn then
    IdentXY(Image1.Width div 2, Image1.Height div 2)
  else
    Fshowinfo(sc.cfgsc.msg);
  {$endif}
end;
SetScrollBar;
{$ifdef trace_debug}
 WriteTrace('Chart '+sc.cfgsc.chartname+': Refresh end');
{$endif}
end;

procedure Tf_chart.UndoExecute(Sender: TObject);
var i,j : integer;
begin
if locked then exit;
{$ifdef trace_debug}
 WriteTrace(caption+' UndoExecute');
{$endif}
zoomstep:=0;
i:=curundo-1;
j:=lastundo+1;
if i<1 then i:=maxundo;
if j>maxundo then j:=1;
if (i<=validundo)and(i<>lastundo)and((i<lastundo)or(i>=j)) then begin
  curundo:=i;
  sc.cfgsc.Assign(undolist[curundo]);
  sc.plot.init(Image1.width,Image1.height);
  sc.Refresh;
  Image1.Invalidate;
  if assigned(FUpdateBtn) then FUpdateBtn(sc.cfgsc.flipx,sc.cfgsc.flipy,Connect1.checked,self);
  if assigned(fshowtopmessage) then fshowtopmessage(sc.GetChartInfo,self);
  if assigned(FChartMove) then FChartMove(self);
  SetScrollBar;
end;
end;

procedure Tf_chart.RedoExecute(Sender: TObject);
var i,j : integer;
begin
if locked then exit;
{$ifdef trace_debug}
 WriteTrace(caption+' RedoExecute');
{$endif}
zoomstep:=0;
i:=curundo+1;
j:=lastundo+1;
if i>maxundo then i:=1;
if j>maxundo then j:=1;
if (i<=validundo)and(i<>j)and((i<=lastundo)or(i>j)) then begin
  curundo:=i;
  sc.cfgsc.Assign(undolist[curundo]);
  sc.plot.init(Image1.width,Image1.height);
  sc.Refresh;
  Image1.Invalidate;
  if assigned(FUpdateBtn) then FUpdateBtn(sc.cfgsc.flipx,sc.cfgsc.flipy,Connect1.checked,self);
  if assigned(fshowtopmessage) then fshowtopmessage(sc.GetChartInfo,self);
  if assigned(FChartMove) then FChartMove(self);
  SetScrollBar;
end;
end;

procedure Tf_chart.ChartResize(Sender: TObject);
begin
if locked or (fsCreating in FormState) then exit;
{$ifdef trace_debug}
 WriteTrace(caption+' ChartResize');
{$endif}
RefreshTimer.Enabled:=false;
RefreshTimer.Enabled:=true;
if sc<>nil then begin
  sc.plot.init(Image1.width,Image1.height);
end;
end;

procedure Tf_chart.SetScrollBar;
var i: integer;
begin
lockscrollbar:=true;
try
if VertScrollBar.Visible then
with sc do begin
 if cfgsc.Projpole=AltAz then begin
    HorScrollBar.Position:=round(rmod(cfgsc.acentre+pi2,pi2)*rad2deg*3600);
    VertScrollBar.Position:=-round(cfgsc.hcentre*rad2deg*3600);
 end
 else if cfgsc.Projpole=Gal then begin
    HorScrollBar.Position:=round(rmod(pi2-cfgsc.lcentre+pi2,pi2)*rad2deg*3600);
    VertScrollBar.Position:=-round(cfgsc.bcentre*rad2deg*3600);
 end
 else if cfgsc.Projpole=Ecl then begin
    HorScrollBar.Position:=round(rmod(pi2-cfgsc.lecentre+pi2,pi2)*rad2deg*3600);
    VertScrollBar.Position:=-round(cfgsc.becentre*rad2deg*3600);
 end
 else begin // Equ
    HorScrollBar.Position:=round(rmod(pi2-cfgsc.racentre+pi2,pi2)*rad2deg*3600);
    VertScrollBar.Position:=-round(cfgsc.decentre*rad2deg*3600);
 end;
 i:=round(rad2deg*3600*cfgsc.fov/90);
 if i<1 then i:=1;
 if i>3600 then i:=3600;
 VertScrollBar.SmallChange:=i;
 VertScrollBar.LargeChange:=8*VertScrollBar.SmallChange;
 VertScrollBar.PageSize:=VertScrollBar.LargeChange;
 HorScrollBar.SmallChange:=i;
 HorScrollBar.LargeChange:=8*HorScrollBar.SmallChange;
 HorScrollBar.PageSize:=HorScrollBar.LargeChange;
// application.ProcessMessages;
 ShowCoord(Image1.Width div 2, Image1.Height div 2);
end;
finally
lockscrollbar:=false;
end;
end;

procedure Tf_chart.HorScrollBarChange(Sender: TObject);
var i: integer;
begin
  HorScrollBarScroll(Sender,scTrack,i);
end;

procedure Tf_chart.HorScrollBarScroll(Sender: TObject; ScrollCode: TScrollCode;
  var ScrollPos: Integer);
begin
{$ifdef trace_debug}
 WriteTrace(caption+' HorScrollBarScroll');
{$endif}
{$ifdef mswindows}
if ScrollCode in [scPageUp,scPageDown] then exit; // do not refresh while scrolling scEndScroll do the final refresh
{$endif}
if lockscrollbar then exit;
lockscrollbar:=true;
try
with sc do begin
 cfgsc.TrackOn:=false;
 cfgsc.Quick:=true;
 if cfgsc.Projpole=AltAz then begin
    cfgsc.acentre:=rmod(deg2rad*HorScrollBar.Position/3600+pi2,pi2);
    Hz2Eq(cfgsc.acentre,cfgsc.hcentre,cfgsc.racentre,cfgsc.decentre,cfgsc);
    cfgsc.racentre:=cfgsc.CurST-cfgsc.racentre;
 end
 else if cfgsc.Projpole=Gal then begin
    cfgsc.lcentre:=rmod(pi2-deg2rad*HorScrollBar.Position/3600+pi2,pi2);
    Gal2Eq(cfgsc.lcentre,cfgsc.bcentre,cfgsc.racentre,cfgsc.decentre,cfgsc);
 end
 else if cfgsc.Projpole=Ecl then begin
    cfgsc.lecentre:=rmod(pi2-deg2rad*HorScrollBar.Position/3600+pi2,pi2);
    Ecl2Eq(cfgsc.lecentre,cfgsc.becentre,cfgsc.ecl,cfgsc.racentre,cfgsc.decentre);
 end
 else begin // Equ
    cfgsc.racentre:=rmod(pi2-deg2rad*HorScrollBar.Position/3600+pi2,pi2);
end;
end;
Refresh;
//application.processmessages;
RefreshTimer.enabled:=false;
RefreshTimer.enabled:=true;
finally
lockscrollbar:=false;
end;
end;

procedure Tf_chart.VertScrollBarChange(Sender: TObject);
var i: integer;
begin
  VertScrollBarScroll(Sender,scTrack,i);
end;

procedure Tf_chart.VertScrollBarScroll(Sender: TObject;
  ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
{$ifdef trace_debug}
 WriteTrace(caption+' VertScrollBarScroll');
{$endif}
{$ifdef mswindows}
if ScrollCode in [scPageUp,scPageDown] then exit; // do not refresh while scrolling scEndScroll do the final refresh
{$endif}
if lockscrollbar then exit;
lockscrollbar:=true;
try
with sc do begin
 cfgsc.TrackOn:=false;
 cfgsc.Quick:=true;
 if cfgsc.Projpole=AltAz then begin
    cfgsc.hcentre:=-deg2rad*VertScrollBar.Position/3600;
    if cfgsc.hcentre>pid2 then cfgsc.hcentre:=pi-cfgsc.hcentre;
    Hz2Eq(cfgsc.acentre,cfgsc.hcentre,cfgsc.racentre,cfgsc.decentre,cfgsc);
    cfgsc.racentre:=cfgsc.CurST-cfgsc.racentre;
 end
 else if cfgsc.Projpole=Gal then begin
    cfgsc.bcentre:=-deg2rad*VertScrollBar.Position/3600;
    if cfgsc.bcentre>pid2 then cfgsc.bcentre:=pi-cfgsc.bcentre;
    Gal2Eq(cfgsc.lcentre,cfgsc.bcentre,cfgsc.racentre,cfgsc.decentre,cfgsc);
 end
 else if cfgsc.Projpole=Ecl then begin
    cfgsc.becentre:=-deg2rad*VertScrollBar.Position/3600;
    if cfgsc.becentre>pid2 then cfgsc.becentre:=pi-cfgsc.becentre;
    Ecl2Eq(cfgsc.lecentre,cfgsc.becentre,cfgsc.ecl,cfgsc.racentre,cfgsc.decentre);
 end
 else begin // Equ
    cfgsc.decentre:=-deg2rad*VertScrollBar.Position/3600;
    if cfgsc.decentre>pid2 then cfgsc.decentre:=pi-cfgsc.decentre;
end;
end;
Refresh;
//application.processmessages;
RefreshTimer.enabled:=false;
RefreshTimer.enabled:=true;
finally
lockscrollbar:=false;
end;
end;

procedure Tf_chart.Image1Paint(Sender: TObject);
begin
if printing then exit;
{$ifdef trace_debug}
 WriteTrace(caption+' Paint');
{$endif}
sc.plot.FlushCnv;
{$ifndef ImageBuffered}
ZoomStep:=0;
if StartCircle then begin
  sc.DrawFinderMark(sc.cfgsc.CircleLst[0,1],sc.cfgsc.CircleLst[0,2],true);
  StartCircle:=false;
  end
else MovingCircle := false;
if (((sc.cfgsc.Trackon)and(sc.cfgsc.TrackType>=1)and(sc.cfgsc.TrackType<=3))or((abs(sc.cfgsc.FindJD-sc.cfgsc.JDchart)<0.001 )))and(sc.cfgsc.TrackName<>rsTelescope)and(sc.cfgsc.TrackName<>'') then begin
   sc.DrawSearchMark(sc.cfgsc.TrackRA,sc.cfgsc.TrackDec,false);
end;
{$endif}
inherited Paint;
{$ifdef ImageBuffered}
if  MovingCircle then begin
  sc.DrawFinderMark(sc.cfgsc.CircleLst[0,1],sc.cfgsc.CircleLst[0,2],true,-1);
end;
if Zoomstep>1 then begin
     with Image1.Canvas do begin
      Pen.Width := 1;
      pen.Color:=clWhite;
      Pen.Mode:=pmXor;
      brush.Style:=bsclear;
      rectangle(Rect(XZoomD1,YZoomD1,XZoomD2,YZoomD2));
      Pen.Mode:=pmCopy;
      brush.Style:=bsSolid;
     end;
end;
if sc.cfgsc.scopemark then begin
   sc.DrawFinderMark(sc.cfgsc.ScopeRa,sc.cfgsc.ScopeDec,true,-1);
end;
if (((sc.cfgsc.Trackon)and(sc.cfgsc.TrackType>=1)and(sc.cfgsc.TrackType<=3))or((abs(sc.cfgsc.FindJD-sc.cfgsc.JDchart)<0.001 )))and(sc.cfgsc.TrackName<>rsTelescope)and(sc.cfgsc.TrackName<>'') then begin
   sc.DrawSearchMark(sc.cfgsc.TrackRA,sc.cfgsc.TrackDec,false);
end;
{$endif}
end;

procedure TChartDrawingControl.Paint;
begin
  inherited Paint;
end;

procedure Tf_chart.RefreshTimerTimer(Sender: TObject);
begin
RefreshTimer.Enabled:=false;
if locked then exit;
//if sc<>nil then sc.plot.init(Image1.width,Image1.height);
{$ifdef trace_debug}
 WriteTrace('Chart '+sc.cfgsc.chartname+': RefreshTimer');
{$endif}
Refresh;
end;

procedure Tf_chart.RemoveAllLabel1Click(Sender: TObject);
begin
{$ifdef trace_debug}
 WriteTrace(caption+' RemoveAllLabel1Click');
{$endif}
sc.cfgsc.poscustomlabels:=0;
sc.cfgsc.numcustomlabels:=0;
Refresh;
end;

procedure Tf_chart.RemoveLastLabel1Click(Sender: TObject);
var j: integer;
begin
{$ifdef trace_debug}
 WriteTrace(caption+' RemoveLastLabel1Click');
{$endif}
if sc.cfgsc.poscustomlabels>0 then begin
  for j:=sc.cfgsc.poscustomlabels+1 to sc.cfgsc.numcustomlabels do
      sc.cfgsc.customlabels[j-1]:=sc.cfgsc.customlabels[j];
  dec(sc.cfgsc.numcustomlabels);
  sc.cfgsc.poscustomlabels:=sc.cfgsc.numcustomlabels;
end;
Refresh;
end;

procedure Tf_chart.search1Click(Sender: TObject);
var ra,de,a,h,l,b,le,be:double;
    i: integer;
    sra,sde,url: string;
begin
 i:=TMenuItem(sender).tag;
 if (i>0) and (i<=infocoord_maxurl) then begin
    sc.GetCoord(xcursor,ycursor,ra,de,a,h,l,b,le,be);
    if sc.cfgsc.ApparentPos then mean_equatorial(ra,de,sc.cfgsc,true,true);
    precession(sc.cfgsc.JDChart,jd2000,ra,de);
    sra:=trim(ARtoStr(rad2deg*ra/15));
    sde:=trim(DEToStr3(rad2deg*de));
    if (Copy(sde,1,1)<>'-') then sde:='%2b'+sde;
    url:=infocoord_url[i,1];
    url:=StringReplace(url,'$RA',sra,[]);
    url:=StringReplace(url,'$DE',sde,[]);
    ExecuteFile(url);
 end;
end;

procedure Tf_chart.nsearch1Click(Sender: TObject);
var i: integer;
    url,n: string;
begin
i:=TMenuItem(sender).tag;
if (i>0) and (i<=infoname_maxurl) then begin
  n:=sc.cfgsc.FindName;
  if pos('BSC',n)=1 then Delete(n,1,3);
  if pos('Sky',n)=1 then Delete(n,1,3);
  n:=StringReplace(n,' ','%20',[rfReplaceAll]);
  n:=StringReplace(n,'+','%2b',[rfReplaceAll]);
  n:=StringReplace(n,'.','%20',[rfReplaceAll]);
  url:=infoname_url[i,1];
  url:=StringReplace(url,'$ID',n,[]);
  ExecuteFile(url);
end;
end;

procedure Tf_chart.SlewCursorClick(Sender: TObject);
var ra,dec,a,h,l,b,le,be:double;
begin
  sc.GetCoord(xcursor,ycursor,ra,dec,a,h,l,b,le,be);
  sc.cfgsc.FindRA:=ra;
  sc.cfgsc.FindDEC:=dec;
  sc.cfgsc.FindName:='cursor';
  Slew1Click(sender);
end;

procedure Tf_chart.Target1Click(Sender: TObject);
begin
if sc.cfgsc.TargetOn then begin
   {$ifdef trace_debug}
    WriteTrace('Target click 1');
   {$endif}
   sc.cfgsc.TargetOn:=false;
   Refresh;
end else if ((sc.cfgsc.TrackType>=1)and(sc.cfgsc.TrackType<=3))or(sc.cfgsc.TrackType=6)
then begin
   {$ifdef trace_debug}
   WriteTrace('Target click 2');
   {$endif}
   sc.cfgsc.TargetOn:=true;
   sc.cfgsc.TargetName:=sc.cfgsc.TrackName;
   sc.cfgsc.TargetRA:=sc.cfgsc.TrackRA;
   sc.cfgsc.TargetDec:=sc.cfgsc.TrackDec;
   Refresh;
end;
end;

procedure Tf_chart.TrackTelescopeClick(Sender: TObject);
begin
if sc.cfgsc.TrackOn and(sc.cfgsc.TrackName=rsTelescope) then begin
   sc.cfgsc.TrackOn:=false;
{$ifdef trace_debug}
WriteTrace('Track Telescope 1');
{$endif}
   Refresh;
end else if Connect1.Checked then begin
{$ifdef trace_debug}
 WriteTrace('Track Telescope 2');
{$endif}
   sc.cfgsc.TrackOn:=true;
   sc.cfgsc.TrackType:=6;
   sc.cfgsc.TrackName:=rsTelescope;
   sc.cfgsc.TrackRA:=sc.cfgsc.ScopeRa;
   sc.cfgsc.TrackDec:=sc.cfgsc.ScopeDec;
   sc.cfgsc.scopemark:=true;
   sc.MovetoRaDec(sc.cfgsc.ScopeRa,sc.cfgsc.ScopeDec);
   Refresh;
end;
if Sender is TMenuItem then TMenuItem(Sender).Checked:=(sc.cfgsc.TrackOn and (sc.cfgsc.TrackName=rsTelescope));
end;

Procedure FixPostscript(fn: string; printlandscape:boolean; pw,ph:integer);
var buf:TStringList;
    i:integer;
begin
buf:=TStringList.Create;
buf.LoadFromFile(fn);
if printlandscape then begin
   i:=buf.IndexOf('%%Page: 1 1')+1;
   if i>1 then begin
     buf.Insert(i,'<< /PageSize ['+inttostr(ph)+' '+inttostr(pw)+'] >> setpagedevice');
   end;
end else begin
   i:=buf.IndexOf('%%Page: 1 1')+1;
   if i>1 then begin
     buf.Insert(i,'<< /PageSize ['+inttostr(pw)+' '+inttostr(ph)+'] >> setpagedevice');
   end;
end;
buf.SaveToFile(fn);
end;

procedure Tf_chart.PrintChart(printlandscape:boolean; printcolor,printmethod,printresol:integer ;printcmd1,printcmd2,printpath:string; cm:Tconf_main; preview:boolean);
var savecolor: Starcolarray;
    savesplot,savenplot,savepplot,savebgcolor,resol,rp: integer;
    rs: single;
    saveskycolor,printok: boolean;
    saveLabelColor : array[1..numlabtype] of Tcolor;
    prtname:string;
    fname:WideString;
    i,w,h,x,y,wh :integer;
    pt:TPoint;
    ps:TPostscriptCanvas;
    previewbmp:Tbitmap;
Procedure InitPrintColor;
var i:integer;
begin
 if printcolor<>2 then begin
   // force line drawing
   sc.plot.cfgplot.starplot:=0;
   sc.plot.cfgplot.nebplot:=0;
   if sc.plot.cfgplot.plaplot=2 then sc.plot.cfgplot.plaplot:=1;
   // ensure white background
   sc.plot.cfgplot.autoskycolor:=false;
   if printcolor=0 then begin
     sc.plot.cfgplot.color[0]:=clWhite;
     sc.plot.cfgplot.color[11]:=clBlack;
   end else begin
     sc.plot.cfgplot.color:=DfWBColor;
   end;
   if printcolor<2 then for i:=1 to numlabtype do sc.plot.cfgplot.LabelColor[i]:=clBlack;
   sc.plot.cfgplot.bgColor:=sc.plot.cfgplot.color[0];
 end;
end;
begin
{$ifdef trace_debug}
 WriteTrace(caption+' PrintChart');
{$endif}
 zoomstep:=0;
 // save current state
 savecolor:=sc.plot.cfgplot.color;
 savesplot:=sc.plot.cfgplot.starplot;
 savenplot:=sc.plot.cfgplot.nebplot;
 savepplot:=sc.plot.cfgplot.plaplot;
 saveskycolor:=sc.plot.cfgplot.autoskycolor;
 savebgcolor:=sc.plot.cfgplot.bgColor;
 for i:=1 to numlabtype do saveLabelColor[i]:=sc.plot.cfgplot.LabelColor[i];
try
 printing:=true;
 screen.cursor:=crHourGlass;
 Case PrintMethod of
 0: begin    // to printer
    GetPrinterResolution(prtname,resol);
    if PrintLandscape then Printer.Orientation:=poLandscape
                      else Printer.Orientation:=poPortrait;
    if preview then begin
      rp:=resol;
      printok:=false;
      PrintPreview:=Tf_image.Create(self);
      previewbmp:=Tbitmap.Create;
      try
        InitPrintColor;
        PrintPreview.ButtonPrint.Visible:=true;
        PrintPreview.Image1.BGcolor:=clBtnFace;
        w:=Printer.PageWidth;
        h:=Printer.PageHeight;
        wh:=max(w,h);
        if wh>1024 then begin
           rs:=1024/wh;
           w:=round(w*rs);
           h:=round(h*rs);
           rp:=round(rp*rs);
        end;
        sc.plot.destcnv:=previewbmp.Canvas;
        sc.plot.cfgplot.UseBMP:=false;
        sc.plot.cfgchart.onprinter:=true;
        sc.plot.cfgchart.drawpen:=maxintvalue([1,rp div 150]);
        sc.plot.cfgchart.drawsize:=maxintvalue([1,rp div 100]);
        sc.plot.cfgchart.fontscale:=1;
        sc.cfgsc.LeftMargin:=mm2pi(cm.PrtLeftMargin,rp);
        sc.cfgsc.RightMargin:=mm2pi(cm.PrtRightMargin,rp);
        sc.cfgsc.TopMargin:=mm2pi(cm.PrtTopMargin,rp);
        sc.cfgsc.BottomMargin:=mm2pi(cm.PrtBottomMargin,rp);
        sc.cfgsc.xshift:=sc.cfgsc.LeftMargin;
        sc.cfgsc.yshift:=sc.cfgsc.TopMargin;
        previewbmp.Width:=w;
        previewbmp.Height:=h;
        sc.plot.init(w,h);
        sc.Refresh;
        if trim(cm.PrintDesc)>'' then begin
         x:=w div 2;
         y:=h-10-sc.cfgsc.BottomMargin;
         sc.plot.PlotText(x,y,6,sc.plot.cfgplot.LabelColor[8],laCenter,laBottom,cm.PrintDesc,sc.cfgsc.WhiteBg);
        end;
        previewbmp.SaveToFile(SysToUTF8(slash(TempDir))+'preview.bmp');
        PrintPreview.LoadImage(SysToUTF8(slash(TempDir))+'preview.bmp');
        PrintPreview.ClientHeight:=Image1.Height;
        PrintPreview.ClientWidth:=Image1.Width;
        PrintPreview.image1.ZoomMin:=0.5;
        PrintPreview.labeltext:=rsPrintPreview;
        PrintPreview.Init;
        pt:=Image1.ClientToScreen(point(0,0));
        FormPos(PrintPreview,pt.x,pt.y);
        screen.cursor:=crDefault;
        PrintPreview.ShowModal;
        printok:=(PrintPreview.ModalResult=mrYes);
      finally
        PrintPreview.Free;
        previewbmp.Free;
      end;
      if not printok then exit;
    end;
    // print
    screen.cursor:=crHourGlass;
    InitPrintColor;
    Printer.Title:='CdC';
    Printer.Copies:=cm.PrintCopies;
    Printer.BeginDoc;
    sc.plot.destcnv:=Printer.canvas;
    sc.plot.cfgplot.UseBMP:=false;
    sc.plot.cfgchart.onprinter:=true;
    sc.plot.cfgchart.drawpen:=maxintvalue([1,resol div 150]);
    sc.plot.cfgchart.drawsize:=maxintvalue([1,resol div 100]);
    sc.plot.cfgchart.fontscale:=1;
    sc.cfgsc.LeftMargin:=mm2pi(cm.PrtLeftMargin,resol);
    sc.cfgsc.RightMargin:=mm2pi(cm.PrtRightMargin,resol);
    sc.cfgsc.TopMargin:=mm2pi(cm.PrtTopMargin,resol);
    sc.cfgsc.BottomMargin:=mm2pi(cm.PrtBottomMargin,resol);
    sc.cfgsc.xshift:=printer.PaperSize.PaperRect.WorkRect.Left+sc.cfgsc.LeftMargin;
    sc.cfgsc.yshift:=printer.PaperSize.PaperRect.WorkRect.Top+sc.cfgsc.TopMargin;
    w:=Printer.PageWidth;
    h:=Printer.PageHeight;
    sc.plot.init(w,h);
    sc.Refresh;
    if trim(cm.PrintDesc)>'' then begin
     x:=w div 2;
     y:=h-10-sc.cfgsc.BottomMargin;
     sc.plot.PlotText(x,y,6,sc.plot.cfgplot.LabelColor[8],laCenter,laBottom,cm.PrintDesc,sc.cfgsc.WhiteBg);
    end;
    Printer.EndDoc;
    end;
 1: begin  // to postscript canvas
    InitPrintColor;
    if assigned(Fshowinfo) then Fshowinfo(rsCreatePostsc , caption);
    if DirectoryIsWritable(printpath) then begin
      ps:=TPostscriptCanvas.Create;
      ps.XDPI := printresol;
      ps.YDPI := printresol;
      if PrintLandscape then begin
         ps.paperwidth:=round(PaperHeight[cm.Paper]*printresol);
         ps.paperheight:=round(PaperWidth[cm.Paper]*printresol);
      end else begin
         ps.paperwidth:=round(PaperWidth[cm.Paper]*printresol);
         ps.paperheight:=round(PaperHeight[cm.Paper]*printresol);
      end;
     // draw the chart
      ps.begindoc;
      sc.plot.destcnv:=ps;
      sc.plot.cfgplot.UseBMP:=false;
      sc.plot.cfgchart.onprinter:=true;
      sc.plot.cfgchart.drawpen:=maxintvalue([1,printresol div 150]);
      sc.plot.cfgchart.drawsize:=maxintvalue([1,printresol div 100]);
      sc.plot.cfgchart.fontscale:=1;
      sc.cfgsc.LeftMargin:=mm2pi(cm.PrtLeftMargin,printresol);
      sc.cfgsc.RightMargin:=mm2pi(cm.PrtRightMargin,printresol);
      sc.cfgsc.TopMargin:=mm2pi(cm.PrtTopMargin,printresol);
      sc.cfgsc.BottomMargin:=mm2pi(cm.PrtBottomMargin,printresol);
      sc.cfgsc.xshift:=sc.cfgsc.LeftMargin;
      sc.cfgsc.yshift:=sc.cfgsc.TopMargin;
      sc.plot.init(ps.pagewidth,ps.pageheight);
      sc.Refresh;
      if trim(cm.PrintDesc)>'' then begin
        x:=ps.pagewidth div 2;
        y:=ps.pageheight-10-sc.cfgsc.BottomMargin;
        sc.plot.PlotText(x,y,6,sc.plot.cfgplot.LabelColor[8],laCenter,laBottom,cm.PrintDesc,sc.cfgsc.WhiteBg);
      end;
      ps.enddoc;
      fname:=slash(printpath)+'cdcprint.ps';
      ps.savetofile(SysToUTF8(fname));
      FixPostscript(fname,PrintLandscape,round(PaperWidth[cm.Paper]*72),round(PaperHeight[cm.Paper]*72));
      ps.Free;
      chdir(appdir);
      if assigned(Fshowinfo) then Fshowinfo(rsSendChartToP , caption);
      execnowait(printcmd1+' "'+fname+'"');
    end
      else if assigned(Fshowinfo) then Fshowinfo(rsInvalidPath+printpath , caption);
    end;
 2: begin  // to bitmap
    InitPrintColor;
    if assigned(Fshowinfo) then Fshowinfo(Format(rsCreateRaster, [inttostr(printresol)]) , caption);
    if DirectoryIsWritable(printpath) then begin
      if PrintLandscape then begin
         w:=11*printresol;
         h:=8*printresol;
      end else begin
         w:=8*printresol;
         h:=11*printresol;
      end;
     // draw the chart to the bitmap
     sc.plot.cfgplot.UseBMP:=true;
     sc.plot.cfgchart.onprinter:=(PrintColor<2);
     sc.plot.cfgchart.drawpen:=maxintvalue([1,printresol div 150]);
     sc.plot.cfgchart.drawsize:=maxintvalue([1,printresol div 100]);
     sc.plot.cfgchart.fontscale:=sc.plot.cfgchart.drawsize; // because we cannot set a dpi property for the bitmap
     sc.cfgsc.LeftMargin:=0;
     sc.cfgsc.RightMargin:=0;   // No margin on bitmap file
     sc.cfgsc.TopMargin:=0;
     sc.cfgsc.BottomMargin:=0;
     sc.cfgsc.xshift:=sc.cfgsc.LeftMargin;
     sc.cfgsc.yshift:=sc.cfgsc.TopMargin;
     sc.plot.init(w,h);
     sc.Refresh;
      if trim(cm.PrintDesc)>'' then begin
        x:=w div 2;
        y:=h-10-sc.cfgsc.BottomMargin;
        sc.plot.PlotText(x,y,6,sc.plot.cfgplot.LabelColor[8],laCenter,laBottom,cm.PrintDesc,sc.cfgsc.WhiteBg);
      end;
     // save the bitmap
     fname:=slash(printpath)+'cdcprint.bmp';
     sc.plot.cbmp.savetofile(SysToUTF8(fname));
     if printcmd2<>'' then begin
        if assigned(Fshowinfo) then Fshowinfo(rsOpenTheBitma , caption);
        execnowait(printcmd2+' "'+fname+'"','',false);
     end;
 end
   else if assigned(Fshowinfo) then Fshowinfo(rsInvalidPath+printpath , caption);
 end;
end;
finally
 printing:=false;
 chdir(appdir);
 screen.cursor:=crDefault;
 // restore state
 sc.plot.cfgplot.UseBMP:=true;
 sc.plot.cfgplot.color:=savecolor;
 sc.plot.cfgplot.starplot:=savesplot;
 sc.plot.cfgplot.nebplot:=savenplot;
 sc.plot.cfgplot.plaplot:=savepplot;
 sc.plot.cfgplot.autoskycolor:=saveskycolor;
 sc.plot.cfgplot.bgColor:=savebgcolor;
 for i:=1 to numlabtype do sc.plot.cfgplot.LabelColor[i]:=saveLabelColor[i];
 sc.cfgsc.xshift:=0;
 sc.cfgsc.yshift:=0;
 sc.cfgsc.LeftMargin:=0;
 sc.cfgsc.RightMargin:=0;
 sc.cfgsc.TopMargin:=0;
 sc.cfgsc.BottomMargin:=0;
 // redraw to screen
 sc.plot.destcnv:=Image1.canvas;
 sc.plot.cfgchart.onprinter:=false;
 sc.plot.cfgchart.drawpen:=1;
 sc.plot.cfgchart.drawsize:=1;
 sc.plot.cfgchart.fontscale:=1;
 sc.plot.init(Image1.width,Image1.height);
 sc.Refresh;
 Image1.Invalidate;
 SetScrollBar;
end;
end;

procedure Tf_chart.ChartActivate;
begin
// code to execute when the chart get focus.
{$ifdef trace_debug}
 WriteTrace(caption+' ChartActivate');
{$endif}
if assigned(FUpdateBtn) then FUpdateBtn(sc.cfgsc.flipx,sc.cfgsc.flipy,Connect1.checked,self);
if assigned(fshowtopmessage) then fshowtopmessage(sc.GetChartInfo,self);
if sc.cfgsc.FindOk and assigned(Fshowinfo) then Fshowinfo(sc.cfgsc.FindDesc,caption,false,nil,sc.cfgsc.FindDesc2);
end;

procedure Tf_chart.FlipxExecute(Sender: TObject);
begin
{$ifdef trace_debug}
 WriteTrace(caption+' FlipxExecute');
{$endif}
 sc.cfgsc.FlipX:=-sc.cfgsc.FlipX;
 if sc.cfgsc.FlipX<0 then sc.cfgsc.FlipY:=1;
 if assigned(FUpdateBtn) then FUpdateBtn(sc.cfgsc.flipx,sc.cfgsc.flipy,Connect1.checked,self);
 Refresh;
end;

procedure Tf_chart.FlipyExecute(Sender: TObject);
begin
{$ifdef trace_debug}
 WriteTrace(caption+' FlipyExecute');
{$endif}
 sc.cfgsc.FlipY:=-sc.cfgsc.FlipY;
 if sc.cfgsc.FlipY<0 then sc.cfgsc.FlipX:=1;
 if assigned(FUpdateBtn) then FUpdateBtn(sc.cfgsc.flipx,sc.cfgsc.flipy,Connect1.checked,self);
 Refresh;
end;

procedure Tf_chart.MoveCamera(angle:single);
var rot: single;
begin
if movecam then begin
  sc.cfgsc.rectangle[movecamnum,3]:=sc.cfgsc.rectangle[movecamnum,3]+angle;
  sc.cfgsc.rectangle[movecamnum,3]:=rmod(sc.cfgsc.rectangle[movecamnum,3]+360,360);
  rot:=sc.cfgsc.rectangle[movecamnum,3];
end;
if moveguide then begin
  case moveguidetype of
    0:begin
       sc.cfgsc.circle[moveguidenum,2]:=sc.cfgsc.circle[moveguidenum,2]+angle;
       sc.cfgsc.circle[moveguidenum,2]:=rmod(sc.cfgsc.circle[moveguidenum,2]+360,360);
       rot:=sc.cfgsc.circle[moveguidenum,2];
      end;
    1:begin
       sc.cfgsc.rectangle[moveguidenum,3]:=sc.cfgsc.rectangle[moveguidenum,3]+angle;
       sc.cfgsc.rectangle[moveguidenum,3]:=rmod(sc.cfgsc.rectangle[moveguidenum,3]+360,360);
       rot:=sc.cfgsc.rectangle[moveguidenum,3];
      end;
  end;
end;
frommovecam:=true;
Refresh;
if assigned(Fshowinfo) then Fshowinfo(rsRotation+': '+formatfloat(f1,rot));
end;

procedure Tf_chart.SetCameraRotation(cam:integer);
var size,maxsize:double;
    guiderfound:boolean;
    i: integer;
begin
if movecam or moveguide  then begin
  movecam:=false;
  moveguide:=false;
  for i:=1 to 10 do sc.cfgsc.circle[i,4]:=0;
  for i:=1 to 10 do sc.cfgsc.rectangle[i,5]:=0;
end
else begin
  case cam of
    0: begin
        movecam:=true;
        moveguide:=true;
       end;
    1: movecam:=true;
    2: moveguide:=true;
  end;
  if movecam then begin // find main camera (max rectangle size with null offset)
     maxsize:=0;
     for i:=1 to 10 do
        if sc.cfgsc.rectangleok[i] and (sc.cfgsc.rectangle[i,4]=0) then begin
          size:=sc.cfgsc.rectangle[i,1]*sc.cfgsc.rectangle[i,2];
          if size>maxsize then begin
             maxsize:=size;
             movecamnum:=i;
          end;
        end;
     if maxsize=0 then movecam:=false
        else sc.cfgsc.rectangle[movecamnum,5]:=1;
  end;
  if moveguide then begin // find first guider (first circle or rectangle with offset > 0)
     guiderfound:=false;
     for i:=1 to 10 do
        if sc.cfgsc.circleok[i] and (sc.cfgsc.circle[i,3]>0) then begin
           guiderfound:=true;
           moveguidenum:=i;
           moveguidetype:=0;
           sc.cfgsc.circle[i,4]:=1;
           break;
        end;
     if not guiderfound then for i:=1 to 10 do
        if sc.cfgsc.rectangleok[i] and (sc.cfgsc.rectangle[i,4]>0) then begin
           guiderfound:=true;
           moveguidenum:=i;
           moveguidetype:=1;
           sc.cfgsc.rectangle[i,5]:=1;
           break;
        end;
     if not guiderfound then moveguide:=false;
  end;
end;
frommovecam:=true;
Refresh;
end;

procedure Tf_chart.rotation(rot:double);
begin
{$ifdef trace_debug}
 WriteTrace(caption+' rotation');
{$endif}
 sc.cfgsc.theta:=sc.cfgsc.theta+deg2rad*rot;
 Refresh;
end;

procedure Tf_chart.rot_plusExecute(Sender: TObject);
begin
 rotation(15);
end;

procedure Tf_chart.rot_minusExecute(Sender: TObject);
begin
 rotation(-15);
end;

procedure Tf_chart.SwitchCompass(Sender: TObject);
begin
   sc.catalog.cfgshr.ShowCRose:=not sc.catalog.cfgshr.ShowCRose;
   Refresh;
end;

procedure Tf_chart.GridEQExecute(Sender: TObject);
begin
{$ifdef trace_debug}
 WriteTrace(caption+' GridEQExecute');
{$endif}
 sc.cfgsc.ShowEqGrid := not sc.cfgsc.ShowEqGrid;
 Refresh;
end;

procedure Tf_chart.GridExecute(Sender: TObject);
begin
{$ifdef trace_debug}
 WriteTrace(caption+' GridExecute');
{$endif}
 sc.cfgsc.ShowGrid := not sc.cfgsc.ShowGrid;
{ if sc.cfgsc.projpole=Equat then
    sc.cfgsc.ShowEqGrid:=sc.cfgsc.ShowGrid;   }
 Refresh;
end;

procedure Tf_chart.zoomplusExecute(Sender: TObject);
begin
{$ifdef trace_debug}
 WriteTrace(caption+' zoomplusExecute');
{$endif}
sc.zoom(zoomfactor);
Refresh;
end;

procedure Tf_chart.zoomminusExecute(Sender: TObject);
begin
{$ifdef trace_debug}
 WriteTrace(caption+' zoomminusExecute');
{$endif}
sc.zoom(1/zoomfactor);
Refresh;
end;

procedure Tf_chart.zoomplusmoveExecute(Sender: TObject);
begin
{$ifdef trace_debug}
 WriteTrace(caption+' zoomplusmoveExecute');
{$endif}
if sc.cfgsc.FindName>'' then
    sc.MovetoRaDec(sc.cfgsc.FindRA,sc.cfgsc.FindDec)
else
    sc.MovetoXY(xcursor,ycursor);
sc.zoom(zoomfactor);
sc.cfgsc.TrackOn:=false;
Refresh;
end;

procedure Tf_chart.zoomminusmoveExecute(Sender: TObject);
begin
{$ifdef trace_debug}
 WriteTrace(caption+' zoomminusmoveExecute');
{$endif}
if sc.cfgsc.FindName>'' then
    sc.MovetoRaDec(sc.cfgsc.FindRA,sc.cfgsc.FindDec)
else
    sc.MovetoXY(xcursor,ycursor);
sc.zoom(1/zoomfactor);
sc.cfgsc.TrackOn:=false;
Refresh;
end;

procedure Tf_chart.MoveWestExecute(Sender: TObject);
begin
{$ifdef trace_debug}
 WriteTrace(caption+' MoveWestExecute');
{$endif}
 sc.MoveChart(0,-1,movefactor);
 Refresh;
end;

procedure Tf_chart.MoveEastExecute(Sender: TObject);
begin
{$ifdef trace_debug}
 WriteTrace(caption+' MoveEastExecute');
{$endif}
 sc.MoveChart(0,1,movefactor);
 Refresh;
end;

procedure Tf_chart.MoveNorthExecute(Sender: TObject);
begin
{$ifdef trace_debug}
 WriteTrace(caption+' MoveNorthExecute');
{$endif}
 sc.MoveChart(1,0,movefactor);
 Refresh;
end;

procedure Tf_chart.MoveSouthExecute(Sender: TObject);
begin
 sc.MoveChart(-1,0,movefactor);
{$ifdef trace_debug}
 WriteTrace(caption+' MoveSouthExecute');
{$endif}
 Refresh;
end;

procedure Tf_chart.MoveNorthWestExecute(Sender: TObject);
begin
 sc.MoveChart(1,-1,movefactor);
{$ifdef trace_debug}
 WriteTrace(caption+' MoveNorthWestExecute');
{$endif}
 Refresh;
end;

procedure Tf_chart.MoveNorthEastExecute(Sender: TObject);
begin
 sc.MoveChart(1,1,movefactor);
{$ifdef trace_debug}
 WriteTrace(caption+' MoveNorthEastExecute');
{$endif}
 Refresh;
end;

procedure Tf_chart.MoveSouthWestExecute(Sender: TObject);
begin
 sc.MoveChart(-1,-1,movefactor);
{$ifdef trace_debug}
 WriteTrace(caption+' MoveSouthWestExecute');
{$endif}
 Refresh;
end;

procedure Tf_chart.MoveSouthEastExecute(Sender: TObject);
begin
 sc.MoveChart(-1,1,movefactor);
{$ifdef trace_debug}
 WriteTrace(caption+' MoveSouthEastExecute');
{$endif}
 Refresh;
end;

procedure Tf_chart.CKeyDown(var Key: Word; Shift: TShiftState);
begin
if LockKeyboard then exit;
try
LockKeyboard:=true;
movefactor:=6;
zoomfactor:=2;
if Shift = [ssShift] then begin
   movefactor:=12;
   zoomfactor:=1.5;
end;
if Shift = [ssCtrl] then begin
   movefactor:=4;
   zoomfactor:=3;
end;
case key of
key_upright   : MoveNorthWest.execute;
key_downright : MoveSouthWest.execute;
key_downleft  : MoveSouthEast.execute;
key_upleft    : MoveNorthEast.execute;
key_left      : if (movecam or moveguide) then MoveCamera(5) else MoveEast.execute;
key_up        : MoveNorth.execute;
key_right     : if (movecam or moveguide) then MoveCamera(-5) else MoveWest.execute;
key_down      : MoveSouth.execute;
key_del       : Cleanupmap1Click(nil);
end;
movefactor:=4;
zoomfactor:=2;
application.processmessages;  // very important to empty the mouse event queue before to unlock
finally
LockKeyboard:=false;
end;
end;

procedure Tf_chart.PopupMenu1Popup(Sender: TObject);
begin
 xcursor:=Image1.ScreenToClient(mouse.cursorpos).x;
 ycursor:=Image1.ScreenToClient(mouse.cursorpos).y;
 IdentXY(xcursor, ycursor);
 if sc.cfgsc.TrackOn then begin
    TrackOff1.visible:=true;
    TrackOn1.visible:=false;
 end else begin
    TrackOff1.visible:=false;
    if ((sc.cfgsc.TrackType>=1)and(sc.cfgsc.TrackType<=3))or(sc.cfgsc.TrackType=6) then begin
      TrackOn1.Caption:=Format(rsLockOn, [sc.cfgsc.TrackName]);
      TrackOn1.visible:=true;
    end
    else TrackOn1.visible:=false;
 end;
 if sc.cfgsc.TargetOn then begin
    Target1.Caption:=rsClearTarget;
  end else if ((sc.cfgsc.TrackType>=1)and(sc.cfgsc.TrackType<=3))or(sc.cfgsc.TrackType=6) then begin
    Target1.Caption:=Format(rsSetTargetTo, [sc.cfgsc.TrackName]);
  end else begin
    Target1.Caption:=rsNoTargetObje;
 end;
 if sc.cfgsc.FindName>'' then begin
   About1.Caption:=Format(rsAbout2, [sc.cfgsc.FindName]);
   About1.visible:=true;
   About2.visible:=true;
   SearchName1.Visible:=true;
 end
 else begin
   About1.visible:=false;
   About2.visible:=false;
   SearchName1.Visible:=False;
 end;
 if sc.cfgsc.ManualTelescope then
    Telescope1.Visible:=false
 else
    Telescope1.Visible:=true;
end;

procedure Tf_chart.TrackOn1Click(Sender: TObject);

begin
  sc.cfgsc.TrackOn:=true;
{$ifdef trace_debug}
 WriteTrace(caption+' TrackOn1Click');
{$endif}
  Refresh;
end;

procedure Tf_chart.TrackOff1Click(Sender: TObject);

begin
  sc.cfgsc.TrackOn:=false;
{$ifdef trace_debug}
 WriteTrace(caption+' TrackOff1Click');
{$endif}
  Refresh;
end;

procedure Tf_chart.CentreExecute(Sender: TObject);
begin
  if sc.cfgsc.FindName>'' then
      sc.MovetoRaDec(sc.cfgsc.FindRA,sc.cfgsc.FindDec)
  else
      sc.MovetoXY(xcursor,ycursor);
  sc.cfgsc.TrackOn:=false;
{$ifdef trace_debug}
 WriteTrace(caption+' CentreExecute');
{$endif}
  Refresh;
end;

procedure Tf_chart.CopyCoord1Click(Sender: TObject);
var txt: string;
    ra,dec,a,h,l,b,le,be:double;
begin
  if sc.cfgsc.FindName>'' then begin
      ra:=sc.cfgsc.FindRA;
      dec:=sc.cfgsc.FindDec;
  end else begin
      sc.GetCoord(xcursor,ycursor,ra,dec,a,h,l,b,le,be);
  end;
  txt:=ARtoStr(ra*rad2deg/15)+blank+DEToStr(dec*rad2deg);
  Clipboard.AsText:=txt;
end;

procedure Tf_chart.Image1MouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
handled:=true;
//lock_TrackCursor:=true;
if wheeldelta>0 then sc.Zoom(1.25)
                else sc.Zoom(0.8);
{$ifdef trace_debug}
 WriteTrace(caption+' Image1MouseWheel');
{$endif}
Refresh;
end;

Procedure Tf_chart.ShowIdentLabel;
var x,y : integer;
begin
if locked then exit;
if sc.cfgsc.FindOK then begin
   sc.plot.FlushCnv;
   identlabel.Visible:=false;
   identlabel.font.name:=sc.plot.cfgplot.fontname[2];
   identlabel.font.size:=sc.plot.cfgplot.fontSize[2];
   identlabel.caption:=trim(sc.cfgsc.FindName);
   sc.GetLabPos(sc.cfgsc.FindRA,sc.cfgsc.FindDec,sc.cfgsc.FindSize/2,identlabel.Width,identlabel.Height,x,y);
   identlabel.left:=x;
   identlabel.top:=y;
   identlabel.Visible:=true;
   identlabel.Cursor:=crHandPoint;
   identlabel.bringtofront;
   sc.DrawSearchMark(sc.cfgsc.FindRA,sc.cfgsc.FindDec,false);
   sc.cfgsc.FindJD:=sc.cfgsc.JDChart;
end
else identlabel.Visible:=false;
end;

function Tf_chart.IdentXY(X, Y: Integer;searchcenter: boolean= true; showlabel: boolean=true):boolean;
var ra,dec,a,h,a1,h1,l,b,le,be,dx,dy,lastra,lastdec,lasttrra,lasttrde,lastx,lasty,lastz,dist,ds:double;
    pa,lasttype,lastobj: integer;
    txt,lastname,lasttrname,buf: string;
    showdist,solsys,lastsolsys:boolean;
begin
result:=false;
if locked then exit;
showdist:=sc.cfgsc.FindOk;
lastra:=sc.cfgsc.FindRA;
lastdec:=sc.cfgsc.FindDEC;
lastname:=sc.cfgsc.FindName;
lasttrra:=sc.cfgsc.TrackRA;
lasttrde:=sc.cfgsc.TrackDEC;
lasttype:=sc.cfgsc.TrackType;
lastobj:=sc.cfgsc.Trackobj;
lasttrname:=sc.cfgsc.TrackName;
lastX:=sc.cfgsc.FindX;
lastY:=sc.cfgsc.FindY;
lastZ:=sc.cfgsc.FindZ;
lastsolsys:=((sc.cfgsc.Findtype=ftAst)or(sc.cfgsc.Findtype=ftCom)or(sc.cfgsc.Findtype=ftPla))and((sc.cfgsc.FindX+sc.cfgsc.FindY+sc.cfgsc.FindZ)<>0);
sc.GetCoord(x,y,ra,dec,a,h,l,b,le,be);
ra:=rmod(ra+pi2,pi2);
dx:=abs(2/sc.cfgsc.BxGlb); // search a 2 pixel radius
result:=sc.FindatRaDec(ra,dec,dx,searchcenter);
if (not result) then result:=sc.FindatRaDec(ra,dec,3*dx,searchcenter);  //else 6 pixel
if showlabel then ShowIdentLabel;
if showdist then begin
   ra:=sc.cfgsc.FindRA;
   dec:=sc.cfgsc.FindDEC;
   solsys:=((sc.cfgsc.FindType=ftAst)or(sc.cfgsc.FindType=ftCom)or(sc.cfgsc.FindType=ftPla))and((sc.cfgsc.FindX+sc.cfgsc.FindY+sc.cfgsc.FindZ)<>0);
   dist := rad2deg*angulardistance(ra,dec,lastra,lastdec);
   if dist>0 then begin
      pa:=round(rmod(rad2deg*PositionAngle(lastra,lastdec,ra,dec)+360,360));
      txt:=DEptoStr(dist)+' PA:'+inttostr(pa)+ldeg;
      dx:=rmod((rad2deg*(ra-lastra)/15)+24,24);
      if dx>12 then dx:=dx-24;
      dy:=rad2deg*(dec-lastdec);
      txt:=txt+crlf+artostr(dx)+blank+detostr(dy);
      if assigned(Fshowcoord) then Fshowcoord(txt);
      buf:=rsFrom+':  "'+lastname+'" '+rsTo+' "'+sc.cfgsc.FindName+'"'+tab+rsSeparation+': '+txt;
      txt:=stringreplace(buf,crlf,tab+rsOffset+':',[]);
      if assigned(Fshowinfo) then Fshowinfo(txt,caption,true,self);
      if solsys and lastsolsys then begin
         ds:=sqrt((lastX-sc.cfgsc.FindX)*(lastX-sc.cfgsc.FindX)+(lastY-sc.cfgsc.FindY)*(lastY-sc.cfgsc.FindY)+(lastZ-sc.cfgsc.FindZ)*(lastZ-sc.cfgsc.FindZ));
         txt:=txt+tab+rsDistance+': '+FormatFloat(f5,ds)+'au';
      end;
      if sc.cfgsc.ManualTelescope then begin
        case sc.cfgsc.ManualTelescopeType of
         0 : begin
             txt:=Format(rsRATurns2, [txt+tab]);
             txt:=txt+blank+formatfloat(f2,abs(dx*sc.cfgsc.TelescopeTurnsX))+blank;
             if (dx*sc.cfgsc.TelescopeTurnsX)>0 then txt:=Format(rsCW, [txt])
                else txt:=Format(rsCCW, [txt]);
             txt:=Format(rsDECTurns2, [txt+tab]);
             txt:=txt+blank+formatfloat(f2,abs(dy*sc.cfgsc.TelescopeTurnsY))+blank;
             if (dy*sc.cfgsc.TelescopeTurnsY)>0 then txt:=Format(rsCW, [txt])
                else txt:=Format(rsCCW, [txt]);
             end;
         1 : begin
             Eq2Hz(sc.cfgsc.CurSt-ra,dec,a,h,sc.cfgsc) ;
             Eq2Hz(sc.cfgsc.CurSt-lastra,lastdec,a1,h1,sc.cfgsc) ;
             dx:=rmod((rad2deg*(a-a1))+360,360);
             if dx>180 then dx:=dx-360;
             dy:=rad2deg*(h-h1);
             txt:=Format(rsAzTurns, [txt+tab]);
             txt:=txt+blank+formatfloat(f2,abs(dx*sc.cfgsc.TelescopeTurnsX))+blank;
             if (dx*sc.cfgsc.TelescopeTurnsX)>0 then txt:=Format(rsCW, [txt])
                else txt:=Format(rsCCW, [txt]);
             txt:=Format(rsAltTurns, [txt+tab]);
             txt:=txt+blank+formatfloat(f2,abs(dy*sc.cfgsc.TelescopeTurnsY))+blank;
             if (dy*sc.cfgsc.TelescopeTurnsY)>0 then txt:=Format(rsCW, [txt])
                else txt:=Format(rsCCW, [txt]);
             end;
          end;
      end;
      sc.cfgsc.FindNote:=txt+tab+sc.cfgsc.FindNote;
      skipmove:=10;
   end;
end;
if sc.cfgsc.TrackOn then begin
//  sc.cfgsc.FindRA:=lastra;
//  sc.cfgsc.FindDEC:=lastdec;
//  sc.cfgsc.FindName:=lastname;
  sc.cfgsc.TrackRA:=lasttrra;
  sc.cfgsc.TrackDEC:=lasttrde;
  sc.cfgsc.TrackType:=lasttype;
  sc.cfgsc.Trackobj:=lastobj;
  sc.cfgsc.TrackName:=lasttrname;
end;
if assigned(Fshowinfo) then Fshowinfo(sc.cfgsc.FindDesc,caption,true,self,sc.cfgsc.FindDesc2);
end;

function Tf_chart.ListXY(X, Y: Integer):boolean;
var ra,dec,a,h,l,b,le,be,dx:double;
    buf,msg:string;
begin
result:=false;
if locked then exit;
sc.GetCoord(x,y,ra,dec,a,h,l,b,le,be);
ra:=rmod(ra+pi2,pi2);
dx:=abs(12/sc.cfgsc.BxGlb); // search a 12 pixel radius
sc.Findlist(ra,dec,dx,dx,buf,msg,false,true,true);
if assigned(FListInfo) then FListInfo(buf,msg);
end;

procedure Tf_chart.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
{$ifdef trace_debug}
 WriteTrace(caption+' MouseUp');
{$endif}
if MovingCircle then begin
   sc.DrawFinderMark(sc.cfgsc.CircleLst[0,1],sc.cfgsc.CircleLst[0,2],true,-1);
   MovingCircle := false;
   if button=mbLeft then begin
      inc(sc.cfgsc.NumCircle);
      GetAdXy(Xcursor,Ycursor,sc.cfgsc.CircleLst[sc.cfgsc.NumCircle,1],sc.cfgsc.CircleLst[sc.cfgsc.NumCircle,2],sc.cfgsc);
      Refresh;
   end;
end
else if (button=mbLeft)and sc.cfgsc.ShowScale then begin
   MeasureDistance(3,X,Y);
end
else if (button=mbLeft)and((shift=[])or(shift=[ssLeft])) then begin
   if zoomstep>0 then begin
     ZoomBox(3,X,Y);
   end
   else begin
     IdentXY(x,y);
     xcursor:=x;
     ycursor:=y;
   end;
end
else if (button=mbLeft)and(ssCtrl in shift) then begin
   IdentXY(x,y,false);
end
else if (button=mbLeft)and(ssShift in shift)and(not lastquick) then begin
   ZoomBox(4,0,0);
   ListXY(x,y);
end
else if (button=mbMiddle)or((button=mbLeft)and(ssShift in shift)) then begin
   if TrackCursorMove then TrackCursor(X,Y);
   Image1.Cursor:=ChartCursor;
   Refresh;
end;
end;


procedure Tf_chart.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
{$ifdef trace_debug}
 WriteTrace(caption+' MouseDown');
{$endif}
lastx:=x;
lasty:=y;
TrackCursorMove:=false;
GetCoordxy(x,y,lastl,lastb,sc.cfgsc);
lastyzoom:=y;
case Button of
   mbLeft  : if sc.cfgsc.ShowScale then  MeasureDistance(1,X,Y)
               else ZoomBox(1,X,Y);
   mbMiddle: image1.cursor:=crHandPoint;
end;
if assigned(FSetFocus) then FSetFocus(Self);
if assigned(FImageSetFocus) then FImageSetFocus(Sender);
end;

procedure Tf_chart.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var c:double;
begin
if locked then exit;
if lockmove then exit;
if skipmove>0 then begin
   system.dec(skipmove);
   exit;
end;
if MovingCircle then begin
   Xcursor:=x;
   Ycursor:=y;
   sc.DrawFinderMark(sc.cfgsc.CircleLst[0,1],sc.cfgsc.CircleLst[0,2],true,-1);
   GetAdXy(Xcursor,Ycursor,sc.cfgsc.CircleLst[0,1],sc.cfgsc.CircleLst[0,2],sc.cfgsc);
   sc.DrawFinderMark(sc.cfgsc.CircleLst[0,1],sc.cfgsc.CircleLst[0,2],true,-1);
   {$ifdef ImageBuffered}
   Image1.Invalidate;
   {$endif}
end else
if (ssLeft in shift)and(not(ssShift in shift)) then begin
   if sc.cfgsc.ShowScale then  MeasureDistance(2,X,Y)
               else ZoomBox(2,X,Y);
end else if ((ssMiddle in shift)and(not(ssCtrl in Shift)))or((ssLeft in shift)and(ssShift in shift)) then begin
     TrackCursor(X,Y);
end else if Shift=[ssCtrl] then begin
     try
     lockmove:=true;
     IdentXY(x,y,true,false);
     Application.ProcessMessages;
     finally
     lockmove:=false;
     end;
end else if ((ssMiddle in shift)and(ssCtrl in Shift)) then begin
     c:=abs(y-lastyzoom)/200;
     if c>1 then c:=1;
     if (y-lastyzoom)>0 then ZoomCursor(1+c)
                        else ZoomCursor(1-c/2);
     lastx:=x;
     lasty:=y;
     lastyzoom:=y;
end else begin
   if lastquick then Refresh; //the mouse as leave during a quick refresh
   if not sc.cfgsc.ShowScale then ShowCoord(x,y);
end;
end;

Procedure Tf_chart.ShowCoord(x,y: Integer);
var ra,dec,a,h,l,b,le,be:double;
    txt:string;
begin
   {show the coordinates}
   sc.GetCoord(x,y,ra,dec,a,h,l,b,le,be);
   case sc.cfgsc.projpole of
   AltAz: begin
          txt:=rsAz+':'+deptostr(rad2deg*a)+blank+deptostr(rad2deg*h)+crlf
              +rsRA+':'+arptostr(rad2deg*ra/15)+blank+deptostr(rad2deg*dec);
          end;
   Equat: begin
          ra:=rmod(ra+pi2,pi2);
          txt:=rsRA+':'+arptostr(rad2deg*ra/15)+blank+deptostr(rad2deg*dec)+crlf
               +rsAz+':'+deptostr(rad2deg*a)+blank+deptostr(rad2deg*h);
          end;
   Gal:   begin
          l:=rmod(l+pi2,pi2);
          txt:=rsL+':'+deptostr(rad2deg*l)+blank+deptostr(rad2deg*b)+crlf
              +rsRA+':'+arptostr(rad2deg*ra/15)+blank+deptostr(rad2deg*dec);
          end;
   Ecl:   begin
          le:=rmod(le+pi2,pi2);
          txt:=rsL+':'+deptostr(rad2deg*le)+blank+deptostr(rad2deg*be)+crlf
              +rsRA+':'+arptostr(rad2deg*ra/15)+blank+deptostr(rad2deg*dec);
          end;
   end;
   if assigned(Fshowcoord) then Fshowcoord(txt);
end;

Procedure Tf_chart.MeasureDistance(action,x,y:integer);
var ra,de,dx,dy,dist,x1,y1: double;
    xx,yy: single;
    pa: integer;
    txt:string;
begin
case action of
1 : begin    // mouse down
     // cleanup last measure
     if MeasureOn then MeasureDistance(4,0,0);
     // begin measure
     GetADxy(X,Y,MeasureRa,MeasureDe,sc.cfgsc);
     // start on object?
     if IdentXY(X,Y,false,true) then begin
       MeasureRa:=sc.cfgsc.FindRA;
       MeasureDe:=sc.cfgsc.FindDec;
       Projection(MeasureRa,MeasureDe,x1,y1,false,sc.cfgsc,false);
       WindowXY(x1,y1,xx,yy,sc.cfgsc);
       X:=round(xx);
       Y:=round(yy);
     end;
     XM1:=X;
     YM1:=Y;
     XMD1:=X;
     YMD1:=Y;
     MeasureOn:=true;
   end;
2,3 : begin    // mouse move, up
    if  MeasureOn then begin
      // clean
      with Image1.Canvas do begin
       Pen.Width := 1;
       pen.Color:=clWhite;
       Pen.Mode:=pmXor;
       brush.Style:=bsclear;
       MoveTo(XM1,YM1);
       LineTo(XMD1,YMD1);
       Pen.Mode:=pmCopy;
       brush.Style:=bsSolid;
      end;
    GetADxy(X,Y,ra,de,sc.cfgsc);
    // end on object?
    if (action=3) and IdentXY(X,Y,false,true) then begin
       ra:=sc.cfgsc.FindRA;
       de:=sc.cfgsc.FindDec;
       Projection(ra,de,x1,y1,false,sc.cfgsc,false);
       WindowXY(x1,y1,xx,yy,sc.cfgsc);
       X:=round(xx);
       Y:=round(yy);
    end;
    dist:=rad2deg*AngularDistance(MeasureRa,MeasureDe,ra,de);
    if dist>0 then begin
      pa:=round(rmod(rad2deg*PositionAngle(MeasureRa,MeasureDe,ra,de)+360,360));
      txt:=DEptoStr(dist)+' PA:'+inttostr(pa)+ldeg;
      dx:=rmod((rad2deg*(ra-MeasureRa)/15)+24,24);
      if dx>12 then dx:=dx-24;
      dy:=rad2deg*(de-MeasureDe);
      txt:=txt+crlf+artostr(dx)+blank+detostr(dy);
      if assigned(Fshowcoord) then Fshowcoord(txt);
    end;
    if action=3 then Image1.Repaint;
    with Image1.Canvas do begin
     Pen.Width := 1;
     pen.Color:=clWhite;
     Pen.Mode:=pmXor;
     brush.Style:=bsclear;
     XMD1:=X;
     YMD1:=Y;
     MoveTo(XM1,YM1);
     LineTo(XMD1,YMD1);
     Pen.Mode:=pmCopy;
     brush.Style:=bsSolid;
    end;
    end;
    end;
4 : begin    // cleanup
    if MeasureOn then
      with Image1.Canvas do begin
       Pen.Width := 1;
       pen.Color:=clWhite;
       Pen.Mode:=pmXor;
       brush.Style:=bsclear;
       MoveTo(XM1,YM1);
       LineTo(XMD1,YMD1);
       Pen.Mode:=pmCopy;
       brush.Style:=bsSolid;
      end;
    MeasureOn:=False;
    end;
end;
end;

Procedure Tf_chart.ZoomBox(action,x,y:integer);
var
   x1,x2,y1,y2,dx,dy,xc,yc,lc : integer;
begin
{$ifdef trace_debug}
// WriteTrace('zoombox '+inttostr(action));
{$endif}
case action of
1 : begin    // mouse down
   ZoomMove:=0;
   if Zoomstep=0 then begin
     // begin zoom
     XZoom1:=X;
     YZoom1:=Y;
     Zoomstep:=1;
   end;
   if Zoomstep=4 then begin
     // move box or confirm click
     DXzoom:=Xzoom1-X;
     DYzoom:=Yzoom1-Y;
     Zoomstep:=4;
   end;
   end;
2 : begin   // mouse move
  if Zoomstep>=3 then  begin
     // move box
     inc(ZoomMove);
     if ZoomMove>2 then zoomstep:=3;
     with Image1.Canvas do begin
      Pen.Width := 1;
      pen.Color:=clWhite;
      Pen.Mode:=pmXor;
      brush.Style:=bsclear;
      rectangle(Rect(XZoomD1,YZoomD1,XZoomD2,YZoomD2));
      dx:=abs(XzoomD2-XzoomD1);
      dy:=abs(YzoomD2-YzoomD1);
      XZoom1:=x+DXZoom;
      YZoom1:=y+DYZoom;
      Xzoom2:=Xzoom1+dx;
      YZoom2:=Yzoom1+dy;
      x1:=round(minvalue([Xzoom1,Xzoom2]));
      x2:=round(maxvalue([Xzoom1,Xzoom2]));
      y1:=round(minvalue([Yzoom1,Yzoom2]));
      y2:=round(maxvalue([Yzoom1,Yzoom2]));
      XzoomD1:=x1;
      XzoomD2:=x2;
      YzoomD1:=y1;
      YzoomD2:=y2;
      rectangle(Rect(XZoomD1,YZoomD1,XZoomD2,YZoomD2));
      Pen.Mode:=pmCopy;
      brush.Style:=bsSolid;
     end;
     if assigned(Fshowcoord) then Fshowcoord(demtostr(rad2deg*abs(dx/sc.cfgsc.Bxglb)));
  end else begin
     // draw zoom box
     inc(ZoomMove);
     if ZoomMove<2 then exit;
     with Image1.Canvas do begin
      Pen.Width := 1;
      pen.Color:=clWhite;
      Pen.Mode:=pmXor;
      brush.Style:=bsClear;
      if Zoomstep>1 then rectangle(Rect(XZoomD1,YZoomD1,XZoomD2,YZoomD2));
      Xzoom2:=x;
      Yzoom2:=Yzoom1+round(sgn(y-Yzoom1)*abs(Xzoom2-Xzoom1)/sc.cfgsc.windowratio);
      x1:=round(minvalue([Xzoom1,Xzoom2]));
      x2:=round(maxvalue([Xzoom1,Xzoom2]));
      y1:=round(minvalue([Yzoom1,Yzoom2]));
      y2:=round(maxvalue([Yzoom1,Yzoom2]));
      XzoomD1:=x1;
      XzoomD2:=x2;
      YzoomD1:=y1;
      YzoomD2:=y2;
      Zoomstep:=2;
      rectangle(Rect(XZoomD1,YZoomD1,XZoomD2,YZoomD2));
      Pen.Mode:=pmCopy;
      brush.Style:=bsSolid;
     end;
     if assigned(Fshowcoord) then Fshowcoord(demtostr(rad2deg*abs((XZoomD2-XZoomD1)/sc.cfgsc.Bxglb)));
     end
    end;
3 : begin   // mouse up
    if zoomstep>=4 then begin
     // final confirmation
      with Image1.Canvas do begin
        Pen.Width := 1;
        Pen.Color:=clWhite;
        Pen.Mode:=pmXor;
        Brush.Style:=bsclear;
        Rectangle(Rect(XZoom1,YZoom1,XZoom2,YZoom2));
        Pen.Mode:=pmCopy;
        Brush.Style:=bsSolid;
      end;
      Zoomstep:=0;
     x1:=trunc(Minvalue([XZoom1,XZoom2])); x2:=trunc(Maxvalue([XZoom1,XZoom2]));
     y1:=trunc(Minvalue([YZoom1,YZoom2])); y2:=trunc(Maxvalue([YZoom1,YZoom2]));
     if (X>=X1) and (X<=X2) and (Y>=Y1) and (Y<=Y2)
        and (X1<>X2 ) and (Y1<>Y2) and (abs(x2-x1)>5) and (abs(y2-y1)>5) then begin
        // do the zoom
        lc := abs(X2-X1);
        xc := round(X1+lc/2);
        yc := round(Y1+(Y2-Y1)/2);
        sc.setfov(abs(lc/sc.cfgsc.BxGlb));
        sc.MovetoXY(xc,yc);
        Refresh;
     end
     else // zoom aborted, nothing to do.
    end else if zoomstep>=2 then begin
        zoomstep:=4  // box size fixed, wait confirmation or move
    end else begin
        // zoom aborted or not initialized
        // box cleanup if necessary
        if Zoomstep>1 then
        with Image1.Canvas do begin
          Pen.Width := 1;
          Pen.Color:=clWhite;
          Pen.Mode:=pmXor;
          Brush.Style:=bsclear;
          Rectangle(Rect(XZoom1,YZoom1,XZoom2,YZoom2));
          Pen.Mode:=pmCopy;
          Brush.Style:=bsSolid;
        end;
        // zoom reset
        Zoomstep:=0;
        // call other mouseup function (identification)
        Image1MouseUp(Self,mbLeft,[],X,Y);
    end;
   end;
4 : begin   // abort
        if Zoomstep>1 then
        with Image1.Canvas do begin
          Pen.Width := 1;
          Pen.Color:=clWhite;
          Pen.Mode:=pmXor;
          Brush.Style:=bsclear;
          Rectangle(Rect(XZoom1,YZoom1,XZoom2,YZoom2));
          Pen.Mode:=pmCopy;
          Brush.Style:=bsSolid;
        end;
        Zoomstep:=0;
   end;
end;
{$ifdef ImageBuffered}
 Image1.Invalidate;
{$endif}
end;

Procedure Tf_chart.TrackCursor(X,Y : integer);
var newl,newb: double;
begin
TrackCursorMove:=true;
if LockTrackCursor then exit;
try
  {$ifdef trace_debug}
   WriteTrace(caption+' TrackCursor');
  {$endif}
   LockTrackCursor:=true;
   image1.cursor:=crHandPoint;
   GetCoordxy(x,y,newl,newb,sc.cfgsc);
   sc.MoveCenter(lastl-newl,lastb-newb);
   sc.cfgsc.quick:=true;
   lastx:=x;
   lasty:=y;
   lastyzoom:=y;
   Refresh;
   application.processmessages;  // very important to empty the mouse event queue before to unlock
finally
LockTrackCursor:=false;
end;
end;

Procedure Tf_chart.ZoomCursor(yy : double);
begin
if LockTrackCursor then exit;
try
   LockTrackCursor:=true;
   yy:=sc.cfgsc.fov*abs(yy);
   if yy<FovMin then yy:=FovMin;
   if yy>FovMax then yy:=FovMax;
   sc.cfgsc.fov:=yy;
{$ifdef trace_debug}
 WriteTrace(caption+' ZoomCursor');
{$endif}
   Refresh;
   application.processmessages;
finally
LockTrackCursor:=false;
end;
end;

procedure Tf_chart.About1Click(Sender: TObject);
begin
  identlabelClick(Sender);
end;

procedure Tf_chart.AddLabel1Click(Sender: TObject);
var ra,dec: double;
begin
GetAdXy(Xcursor,Ycursor,ra,dec,sc.cfgsc);
sc.AddNewLabel(ra,dec);
end;

procedure Tf_chart.BlinkTimerTimer(Sender: TObject);
begin
  BlinkTimer.Enabled:=false;
  sc.cfgsc.ShowBackgroundImage:=not sc.cfgsc.ShowBackgroundImage;
{$ifdef trace_debug}
 WriteTrace(caption+' BlinkTimerTimer');
{$endif}
  Refresh;
  BlinkTimer.Enabled:=true;
end;

procedure Tf_chart.Cleanupmap1Click(Sender: TObject);
begin
ZoomStep:=0;
sc.cfgsc.TargetOn:=false;
sc.cfgsc.Trackon:=false;
sc.cfgsc.TrackName:='';
sc.cfgsc.TrackType:=0;
Refresh;
end;

procedure Tf_chart.identlabelClick(Sender: TObject);
var ra2000,de2000: double;
begin
if (sender<>nil)and(not f_detail.visible) then formpos(f_detail,mouse.cursorpos.x,mouse.cursorpos.y);
f_detail.source_chart:=caption;
ra2000:=sc.cfgsc.FindRA;
de2000:=sc.cfgsc.FindDec;
if sc.cfgsc.ApparentPos then mean_equatorial(ra2000,de2000,sc.cfgsc,true,sc.cfgsc.FindType<ftPla);
precession(sc.cfgsc.JDChart,jd2000,ra2000,de2000);
f_detail.ra:=ra2000;
f_detail.de:=de2000;
f_detail.objname:=sc.cfgsc.FindName;
f_detail.HTMLViewer1.DefFontSize:=sc.plot.cfgplot.FontSize[4];
f_detail.HTMLViewer1.DefFontName:=sc.plot.cfgplot.FontName[4];
f_detail.show;
f_detail.text:=FormatDesc;
f_detail.setfocus;
f_detail.BringToFront;
end;

function Tf_chart.FormatDesc:string;
var desc,buf,buf2,otype,oname,txt: string;
    thr,tht,ths,tazr,tazs,tculmalt: string;
    searchdir,cmd,fn: string;
    bmp: Tbitmap;
    ipla:integer;
    i,p,l,y,m,d,precision : integer;
    isStar, isSolarSystem, isd2k, isvo, isOsr: boolean;
    ApparentValid:boolean;
    ra,dec,a,h,hr,ht,hs,azr,azs,j1,j2,j3,rar,der,rat,det,ras,des,culmalt :double;
    ra2000,de2000,radate,dedate,raapp,deapp,cjd,cjd0,cst: double;

function Bold(s:string):string;
var k:integer;
begin
  k:=pos(':',s);
  if k>0 then begin
     insert(htms_b,s,k+1);
     result:=html_b+s;
  end
  else result:=s;
end;
begin
desc:=sc.cfgsc.FindDesc;
isd2k:=(trim(sc.cfgsc.FindCat)='d2k');
isvo:=(trim(sc.cfgsc.FindCat)='VO');
// header
if NightVision then txt:=html_h_nv
               else txt:=html_h;
// object type
p:=pos(tab,desc);
p:=pos2(tab,desc,p+1);
l:=pos2(tab,desc,p+1);
otype:=trim(copy(desc,p+1,l-p-1));
if otype='*' then precision:=2
else if otype='As' then precision:=2
else if otype='Cm' then precision:=1
else if otype='P' then precision:=1
else if otype='Ps' then precision:=1
else precision:=0;
isStar:=(otype='*');
isSolarSystem:=((otype='P')or(otype='Ps')or(otype='S*')or(otype='As')or(otype='Cm'));
isOsr:=(otype='OSR');
if isSolarSystem and (sc.cfgsc.FindSimjd<>0) then begin
   cjd:=sc.cfgsc.FindSimjd;
   Djd(cjd+(sc.cfgsc.TimeZone-sc.cfgsc.DT_UT)/24,y,m,d,h);
   cjd0:=jd(y,m,d,0);
   cst:=Sidtim(cjd0,h-sc.cfgsc.TimeZone,sc.cfgsc.ObsLongitude,sc.cfgsc.eqeq);
end else begin
   cjd:=sc.cfgsc.CurJD;
   cjd0:=sc.cfgsc.jd0;
   cst:=sc.cfgsc.CurST;
end;
buf:=sc.catalog.LongLabelObj(otype);
txt:=txt+html_h2+buf+htms_h2;
buf:=copy(desc,l+1,9999);
// object name
i:=pos(tab,buf);
oname:=trim(copy(buf,1,i-1));
delete(buf,1,i);
txt:=txt+html_b+oname+htms_b+html_br;
// Planet picture
ipla:=0;
if (otype='P')or((otype='Ps')and(oname=pla[11])) then begin
  for i:=1 to 11 do if pla[i]=oname then ipla:=i;
  if ipla>0 then begin
    { TODO : make a global function with almost the same code in cu_plot }
    searchdir:='"'+slash(appdir)+slash('data')+'planet"';
   {$ifdef linux}
      cmd:='export LC_ALL=C; xplanet';
   {$endif}
   {$ifdef darwin}
      cmd:='export LC_ALL=C; '+'"'+slash(appdir)+slash(xplanet_dir)+'xplanet"';
   {$endif}
   {$ifdef mswindows}
  //    chdir(xplanet_dir);
      cmd:='"'+slash(appdir)+slash(xplanet_dir)+'xplanet.exe"';
   {$endif}
   cmd:=cmd+' -target '+epla[ipla]+' -origin earth -rotate 0'+
        ' -light_time -tt -num_times 1 -jd '+ formatfloat(f5,cjd) +
        ' -searchdir '+searchdir+
        ' -config xplanet.config -verbosity -1'+
        ' -radius 50'+
        ' -geometry 200x200 -output "'+slash(Tempdir)+'info.png'+'"';
   if ipla=5 then cmd:=cmd+' -grs_longitude '+formatfloat(f1,sc.planet.JupGRS(sc.cfgsc.GRSlongitude,sc.cfgsc.GRSdrift,sc.cfgsc.GRSjd,cjd));
   DeleteFile(slash(Tempdir)+'info.png');
   i:=exec(cmd);
   if i=0 then txt:=txt+'<img src="'+slash(TempDir)+'info.png" alt="'+oname+'" border="0" width="200">'+html_br;
 end;
end;
// Sun picture
if (otype='S*')and(oname=pla[10]) then begin
  fn:=slash(systoutf8(Tempdir))+'sun.jpg';
  if not FileExistsutf8(fn) then begin  // use default image
    fn:=slash(systoutf8(appdir))+slash('data')+slash('planet')+'sun-0.jpg';
  end;
  if FileExistsutf8(fn) then txt:=txt+'<img src="'+utf8tosys(fn)+'" alt="'+oname+'" border="0" width="200">'+html_br;
end;
// DSO picture
if sc.Fits.GetFileName(sc.cfgsc.FindCat,oname,fn) then begin
  if (ExtractFileExt(fn)<>'.nil') then begin
       sc.Fits.FileName:=fn;
       if sc.Fits.Header.valid then begin
         bmp:=Tbitmap.Create;
         try
         sc.Fits.min_sigma:=sc.cfgsc.NEBmin_sigma;
         sc.Fits.max_sigma:=sc.cfgsc.NEBmax_sigma;
         sc.Fits.GetBitmap(bmp);
         fn:=slash(systoutf8(TempDir))+'info.bmp';
         DeleteFileutf8(fn);
         bmp.SaveToFile(fn);
         if FileExistsutf8(fn) then txt:=txt+'<img src="'+utf8tosys(fn)+'" alt="'+oname+'" border="0" width="200">'+html_br;
         finally
         bmp.Free;
         end;
        end;
  end;
end;
// source catalog
if isd2k then begin
  txt:=txt+html_b+rsFrom+blank+'Deepsky software'+':'+htms_b+html_br;
end else if isvo then begin
  txt:=txt+html_b+rsFrom+blank+rsVirtualObser+':'+html_br+sc.cfgsc.FindCatname+
    htms_b+html_br;
end else begin
  if (sc.cfgsc.FindCat<>'')or(sc.cfgsc.FindCatname<>'') then begin
    if sc.cfgsc.FindCat='Star' then txt:=txt+html_b+rsInformationF+':'+blank+rsStars
      else txt:=txt+html_b+rsInformationF+':'+blank+sc.cfgsc.FindCat;
  end;
  if sc.cfgsc.FindCatname<>'' then begin
    txt:=txt+html_br+sc.cfgsc.FindCatname;
    txt:=txt+htms_b+html_br;
  end;
end;

// other attribute
repeat
  i:=pos(tab,buf);
  if i=0 then i:=length(buf)+1;
  buf2:=copy(buf,1,i-1);
  delete(buf,1,i);
  if isd2k and(copy(buf2,1,4)='Dim:') then continue;
  if isd2k and(copy(buf2,1,5)='desc:') then buf2:=copy(buf2,6,999);
  if isd2k and(copy(buf2,1,2)='n:') then buf2:=copy(buf2,3,999);
  i:=pos(':',buf2);
  if i>0 then begin
     buf2:=stringreplace(buf2,':',': ',[]);
     if copy(buf2, 1, 5)=rsDesc then buf2:=stringreplace(buf2, ';', html_br+html_sp+html_sp+html_sp, [rfReplaceAll]);
     if isvo or isOsr then
        txt:=txt+bold(buf2)
     else
        txt:=txt+bold(sc.catalog.LongLabel(buf2));
  end
  else
     txt:=txt+buf2;
  txt:=txt+html_br;
until buf='';

// coordinates
ApparentValid:=((sc.cfgsc.nutl<>0)or(sc.cfgsc.nuto<>0)) and (sc.cfgsc.abm or(sc.cfgsc.abp<>0)or(sc.cfgsc.abe<>0));
txt:=txt+html_br+html_b+rsCoordinates+blank;
if sc.cfgsc.CoordExpertMode then begin;
  if sc.cfgsc.ApparentPos and ApparentValid then txt:=txt+blank+rsApparent
     else txt:=txt+blank+rsMean;
  txt:=txt+blank+sc.cfgsc.EquinoxName;
end else
  case sc.cfgsc.CoordType of
  0: if ApparentValid then txt:=txt+blank+rsApparent else txt:=txt+blank+rsMeanOfTheDat;
  1: txt:=txt+blank+rsMeanOfTheDat;
  2: txt:=txt+blank+rsMeanJ2000;
  3: txt:=txt+blank+rsAstrometricJ;
  end;
if isStar then begin
   if sc.cfgsc.PMon and (not sc.cfgsc.FindPM) then txt:=txt+blank+rsNoProperMo
   else if sc.cfgsc.PMon and (sc.cfgsc.YPmon<>0) then txt:=txt+blank+rsEpoch+': '+formatfloat(f1, sc.cfgsc.YPmon);
end;
if isSolarSystem then
   if sc.cfgsc.PlanetParalaxe then txt:=txt+blank+rsTopoCentric
                              else txt:=txt+blank+rsGeocentric;
txt:=txt+htms_b+html_br;
// return to j2000 coord.
ra2000:=sc.cfgsc.FindRA2000;
de2000:=sc.cfgsc.FindDec2000;
//if sc.cfgsc.ApparentPos then mean_equatorial(ra2000,de2000,sc.cfgsc,ipla<>11,not isSolarSystem);
//precession(sc.cfgsc.JDChart,jd2000,ra2000,de2000);
// mean of date, apply only precession
radate:=ra2000;
dedate:=de2000;
precession(jd2000,sc.cfgsc.JDChart,radate,dedate);
// apparent
if ApparentValid then begin
  raapp:=ra2000;
  deapp:=de2000;
  // apply parallax
  if isStar then StarParallax(raapp,deapp,sc.cfgsc.FindPX,sc.cfgsc.EarthB);
  // apply precession
  precession(jd2000,sc.cfgsc.JDChart,raapp,deapp);
  // apply nutation, aberration, light deflection
  apparent_equatorial(raapp,deapp,sc.cfgsc,ipla<>11,not isSolarSystem);
end;
// print coord.
if sc.cfgsc.CoordExpertMode then txt:=txt+rsRA+': '+arptostr(rad2deg*sc.cfgsc.FindRA/15,precision)+'   '+rsDE+':'+deptostr(rad2deg*sc.cfgsc.FindDec, precision)+html_br;
if (sc.cfgsc.CoordType<=1)and ApparentValid then txt:=txt+html_b+rsApparent+blank+htms_b+rsRA+': '+arptostr(rad2deg*raapp/15,precision)+'   '+rsDE+':'+deptostr(rad2deg*deapp, precision)+html_br;
if (sc.cfgsc.CoordType<=1) then txt:=txt+html_b+rsMeanOfTheDat+blank+htms_b+rsRA+': '+arptostr(rad2deg*radate/15,precision)+'   '+rsDE+':'+deptostr(rad2deg*dedate,precision)+html_br;
if isStar and sc.cfgsc.PMon and sc.cfgsc.FindPM and (sc.cfgsc.YPmon=0) then
   txt:=txt+html_b+rsAstrometricJ+htms_b+' '+rsRA+': '+arptostr(rad2deg*ra2000/15,precision)+'   '+rsDE+':'+deptostr(rad2deg*de2000, precision)+html_br
else
   txt:=txt+html_b+rsMeanJ2000+htms_b+' '+rsRA+': '+arptostr(rad2deg*ra2000/15,precision)+'   '+rsDE+':'+deptostr(rad2deg*de2000, precision)+html_br;
ra:=sc.cfgsc.FindRA;
dec:=sc.cfgsc.FindDec;
Eq2Ecl(ra,dec,sc.cfgsc.ecl,a,h) ;
a:=rmod(a+pi2,pi2);
txt:=txt+html_b+rsEcliptic+blank+htms_b+blank+rsL+': '+detostr(rad2deg*a)+blank+rsB+':'+detostr(rad2deg*h)+html_br;
ra:=sc.cfgsc.FindRA;
dec:=sc.cfgsc.FindDec;
if sc.cfgsc.ApparentPos then mean_equatorial(ra,dec,sc.cfgsc,ipla<>11,not isSolarSystem);
Eq2Gal(ra,dec,a,h,sc.cfgsc) ;
a:=rmod(a+pi2,pi2);
txt:=txt+html_b+rsGalactic+blank+htms_b+blank+rsL+': '+detostr(rad2deg*a)+blank+rsB+':'+detostr(rad2deg*h)+html_br;
txt:=txt+html_br;

// local position
txt:=txt+html_b+rsVisibilityFo+':'+htms_b+html_br;
djd(cjd+(sc.cfgsc.TimeZone-sc.cfgsc.DT_UT)/24,y,m,d,h);
txt:=txt+sc.cfgsc.ObsName+blank+Date2Str(y,m,d)+blank+ArToStr3(h)+'  ( '+sc.cfgsc.tz.ZoneName+' )'+html_br;
djd(cjd-sc.cfgsc.DT_UT/24,y,m,d,h);
txt:=txt+html_b+rsUniversalTim+':'+htms_b+blank+date2str(y,m,d)+'T'+timtostr(h);
txt:=txt+blank+'JD='+formatfloat(f5,cjd-sc.cfgsc.DT_UT/24)+html_br;
ra:=sc.cfgsc.FindRA;
dec:=sc.cfgsc.FindDec;
precession(sc.cfgsc.JDChart,cjd,ra,dec);
Eq2Hz(cst-ra,dec,a,h,sc.cfgsc) ;
if sc.catalog.cfgshr.AzNorth then a:=Rmod(a+pi,pi2);
txt:=txt+html_b+rsLocalSideral+':'+htms_b+artostr3(rmod(rad2deg*cst/15+24,24))+html_br;
txt:=txt+html_b+rsHourAngle+':'+htms_b+ARptoStr(rmod(rad2deg*(cst-ra)/15+24,24),-1)+html_br;
txt:=txt+html_b+rsAzimuth+':'+htms_b+deptostr(rad2deg*a,0)+html_br;
txt:=txt+html_b+rsAltitude+':'+htms_b+deptostr(rad2deg*h,0)+html_br;
// rise/set time
if (otype='P') then begin // planet
   sc.planet.PlanetRiseSet(ipla,cjd0,sc.catalog.cfgshr.AzNorth,thr,tht,ths,tazr,tazs,j1,j2,j3,rar,der,rat,det,ras,des,i,sc.cfgsc);
end
else if (otype='S*')and(oname=pla[10]) then begin // Sun
   sc.planet.PlanetRiseSet(10,cjd0,sc.catalog.cfgshr.AzNorth,thr,tht,ths,tazr,tazs,j1,j2,j3,rar,der,rat,det,ras,des,i,sc.cfgsc);
end
else if (otype='Ps')and(ipla=11) then begin // Moon
   sc.planet.PlanetRiseSet(ipla,cjd0,sc.catalog.cfgshr.AzNorth,thr,tht,ths,tazr,tazs,j1,j2,j3,rar,der,rat,det,ras,des,i,sc.cfgsc);
end
else begin // fixed object
     RiseSet(1,cjd0,ra,dec,hr,ht,hs,azr,azs,i,sc.cfgsc);
     if sc.catalog.cfgshr.AzNorth then begin
        Azr:=rmod(Azr+pi,pi2);
        Azs:=rmod(Azs+pi,pi2);
     end;
     thr:=armtostr(rmod(hr+24,24));
     tht:=armtostr(rmod(ht+24,24));
     ths:=armtostr(rmod(hs+24,24));
     tazr:=demtostr(rad2deg*Azr);
     tazs:=demtostr(rad2deg*Azs);
end;
culmalt:= 90 - sc.cfgsc.ObsLatitude + rad2deg*sc.cfgsc.FindDec;
if culmalt>90 then culmalt:=180-culmalt;
if culmalt>-1 then culmalt:=min(90,culmalt+sc.cfgsc.ObsRefractionCor*(1.02/tan(deg2rad*(culmalt+10.3/(culmalt+5.11))))/60)
              else culmalt:=culmalt+0.64658062088;
tculmalt:=demtostr(culmalt);
case i of
0 : begin
    txt:=txt+html_b+rsRise+':'+htms_b+thr+blank;
    if trim(tazr)>'' then txt:=txt+rsAzimuth+tAzr+html_br
                     else txt:=txt+html_br;
    txt:=txt+html_b+rsCulmination+':'+htms_b+tht+blank+tculmalt+html_br;
    txt:=txt+html_b+rsSet+':'+htms_b+ths+blank;
    if trim(tazs)>'' then txt:=txt+rsAzimuth+tAzs+html_br
                     else txt:=txt+html_br;
    end;
1 : begin
    txt:=txt+rsCircumpolar+html_br;
    txt:=txt+html_b+rsCulmination+':'+htms_b+tht+blank+tculmalt+html_br;
    end;
else begin
    txt:=txt+rsInvisibleAtT+html_br;
    end;
end;
// other notes
buf:=sc.cfgsc.FindNote;
if buf>'' then begin
  txt:=txt+html_br;
  repeat
    i:=pos(tab,buf);
    if i=0 then i:=length(buf)+1;
    buf2:=copy(buf,1,i-1);
    delete(buf,1,i);
    i:=pos(':',buf2);
    if i>0 then begin
       txt:=txt+bold(copy(buf2,1,i));
       delete(buf2,1,i);
    end;
    txt:=txt+buf2+html_br;
  until buf='';
end;
// external links
txt:=txt+html_br+html_b+rsMoreInformat+':'+htms_b+html_br;
txt:=txt+rsSearchByName+':'+blank;
for i:=1 to infoname_maxurl do begin
  txt:=txt+'<a href="'+inttostr(i)+'">'+infoname_url[i,2]+'</a>,'+blank;
end;
txt:=txt+html_br;
txt:=txt+rsSearchByPosi+':'+blank;
for i:=1 to infocoord_maxurl do begin
  txt:=txt+'<a href="'+inttostr(i+infoname_maxurl)+'">'+infocoord_url[i,2]+'</a>,'+blank;
end;
txt:=txt+html_br;
//writetrace(txt);
result:=txt+html_br+htms_h;
end;

procedure Tf_chart.switchstarExecute(Sender: TObject);
begin
{$ifdef trace_debug}
 WriteTrace(caption+' switchstarExecute');
{$endif}
dec(sc.plot.cfgplot.starplot);
if sc.plot.cfgplot.starplot<0 then sc.plot.cfgplot.starplot:=2;
if sc.plot.cfgplot.starplot=0 then sc.plot.cfgplot.nebplot:=0
                              else sc.plot.cfgplot.nebplot:=1;
sc.cfgsc.FillMilkyWay:=(sc.plot.cfgplot.nebplot=1);
Refresh;
end;

procedure Tf_chart.switchbackgroundExecute(Sender: TObject);

begin
{$ifdef trace_debug}
 WriteTrace(caption+' switchbackgroundExecute');
{$endif}
sc.plot.cfgplot.autoskycolor:=not sc.plot.cfgplot.autoskycolor;
Refresh;
end;


function Tf_Chart.cmd_SetCursorPosition(x,y:integer) :string;
begin
if (x>=0)and(x<=image1.width)and(y>=0)and(y<=image1.height) then begin
  xcursor:=x;
  ycursor:=y;
  result:=msgOK;
end else result:=msgfailed+' Bad position.';
end;


function Tf_Chart.cmd_GetCursorPosition :string;
begin
result:=msgOK+blank+inttostr(xcursor)+blank+inttostr(ycursor);
end;


function Tf_Chart.cmd_SetGridEQ(onoff:string):string;
begin
 sc.cfgsc.ShowEqGrid := (uppercase(onoff)='ON');
 result:=msgOK;
end;

function Tf_Chart.cmd_GetGridEQ:string;
begin
 if sc.cfgsc.ShowEqGrid then result:=msgOK+' ON'
                        else result:=msgOK+' OFF'
end;

function Tf_Chart.cmd_SetGrid(onoff:string):string;
begin
 sc.cfgsc.ShowGrid := (uppercase(onoff)='ON');
 result:=msgOK;
end;

function Tf_Chart.cmd_GetGrid:string;
begin
 if sc.cfgsc.ShowGrid then result:=msgOK+' ON'
                      else result:=msgOK+' OFF'
end;

function Tf_Chart.cmd_SetGridNum(onoff:string):string;
begin
 sc.cfgsc.ShowGridNum := (uppercase(onoff)='ON');
 result:=msgOK;
end;

function Tf_Chart.cmd_SetConstL(onoff:string):string;
begin
 sc.cfgsc.ShowConstl := (uppercase(onoff)='ON');
 result:=msgOK;
end;

function Tf_Chart.cmd_SetConstB(onoff:string):string;
begin
 sc.cfgsc.ShowConstB := (uppercase(onoff)='ON');
 result:=msgOK;
end;

function Tf_Chart.cmd_SwitchGridNum:string;
begin
 sc.cfgsc.ShowGridNum := not sc.cfgsc.ShowGridNum;
 result:=msgOK;
end;

function Tf_Chart.cmd_SwitchConstL:string;
begin
 sc.cfgsc.ShowConstl := not sc.cfgsc.ShowConstl;
 result:=msgOK;
end;

function Tf_Chart.cmd_SwitchConstB:string;
begin
 sc.cfgsc.ShowConstB := not sc.cfgsc.ShowConstB;
 result:=msgOK;
end;

function Tf_chart.cmd_SetStarMode(i:integer):string;
begin
if (i>=0)and(i<=2) then begin
  sc.plot.cfgplot.starplot:=i;
  result:=msgOK;
end else result:=msgFailed+' Bad star mode.';
end;

function Tf_chart.cmd_GetStarMode:string;
begin
  result:=msgOK+blank+inttostr(sc.plot.cfgplot.starplot);
end;

function Tf_chart.cmd_SetNebMode(i:integer):string;
begin
if (i>=0)and(i<=1) then begin
  sc.plot.cfgplot.nebplot:=i;
  result:=msgOK;
end else result:=msgFailed+' Bad nebula mode.';
end;

function Tf_chart.cmd_GetNebMode:string;
begin
  result:=msgOK+blank+inttostr(sc.plot.cfgplot.nebplot);
end;

function Tf_chart.cmd_SetSkyMode(onoff:string):string;
begin
sc.plot.cfgplot.autoskycolor:=(uppercase(onoff)='ON');
result:=msgOK;
end;

function Tf_chart.cmd_GetSkyMode:string;
begin
 if sc.plot.cfgplot.autoskycolor then result:=msgOK+' ON'
                                 else result:=msgOK+' OFF'

end;

function Tf_chart.cmd_SetProjection(proj:string):string;
begin
result:=msgOK;
proj:=uppercase(proj);
if proj='ALTAZ' then sc.cfgsc.projpole:=altaz
  else if proj='EQUAT' then sc.cfgsc.projpole:=equat
  else if proj='GALACTIC' then sc.cfgsc.projpole:=gal
  else if proj='ECLIPTIC' then sc.cfgsc.projpole:=ecl
  else result:=msgFailed+' Bad projection name.';
sc.cfgsc.FindOk:=false;
end;

function Tf_chart.cmd_GetProjection:string;
begin
case sc.cfgsc.projpole of
equat :  result:='EQUAT';
altaz :  result:='ALTAZ';
gal   :  result:='GALACTIC';
ecl   :  result:='ECLIPTIC';
end;
result:=msgOK+blank+result;
end;

function Tf_chart.cmd_SetFov(fov:string):string;
var f : double;
    p : integer;
begin
result:=msgFailed+' Bad format!';
try
fov:=StringReplace(fov,'FOV:','',[rfIgnoreCase]);
fov:=trim(fov);
p:=pos('d',fov);
if p=0 then p:=pos(#176,fov); // °
if p>0 then begin
  f:=strtofloat(copy(fov,1,p-1));
  fov:=copy(fov,p+1,999);
  p:=pos('m',fov);
  if p=0 then p:=pos('''',fov);
  f:=f+strtofloat(copy(fov,1,p-1))/60;
  fov:=copy(fov,p+1,999);
  p:=pos('s',fov);
  if p=0 then p:=pos('"',fov);
  if p=0 then p:=99;
  f:=f+strtofloat(copy(fov,1,p-1))/3600;
end else begin
  f:=strtofloat(fov);
end;
result:=msgOK;
if (f>0.0006)and(f<=360) then sc.setfov(deg2rad*f) else result:=msgFailed+' FOV out of range';
except
exit;
end;
end;

function Tf_chart.cmd_GetFov(format:string):string;
begin
if format='F' then begin
 result:=msgOK+blank+formatfloat(f5,rad2deg*sc.cfgsc.fov);
end else begin
 result:=msgOK+blank+detostr3(rad2deg*sc.cfgsc.fov);
end
end;

function Tf_chart.cmd_Resize(w,h:string):string;
begin
{$ifdef trace_debug}
 WriteTrace(caption+' cmd_Resize');
{$endif}
width:=StrToIntDef(w,width);
height:=StrToIntDef(h,height);
refresh;
result:=msgOK;
end;

function Tf_chart.cmd_SetRa(param1:string):string;
var buf : string;
    p : integer;
    ar : double;
begin
result:=msgFailed+' Bad coordinates format!';
try
p:=pos('RA:',param1);
if p>0 then begin
 buf:=copy(param1,p+3,999);
 p:=pos('h',buf);
 ar:=strtofloat(copy(buf,1,p-1));
 buf:=copy(buf,p+1,999);
 p:=pos('m',buf);
 ar:=ar+strtofloat(copy(buf,1,p-1))/60;
 buf:=copy(buf,p+1,999);
 p:=pos('s',buf);
 ar:=ar+strtofloat(copy(buf,1,p-1))/3600;
end else begin
 ar:=strtofloat(param1);
end;
result:=msgOK;
if (ar>=0)and(ar<24) then sc.cfgsc.racentre:=rmod(deg2rad*ar*15+pi2,pi2) else result:=msgFailed+' RA out of range';
except
exit;
end;
end;

function Tf_chart.cmd_SetDec(param1:string):string;
var buf : string;
    p : integer;
    s,de : double;
begin
result:=msgFailed+' Bad coordinates format!';
try
p:=pos('DEC:',param1);
if p>0 then begin
 buf:=copy(param1,p+4,999);
 p:=pos('d',buf);
 if p=0 then p:=pos(#176,buf); // °
 de:=strtofloat(copy(buf,1,p-1));
 s:=sgn(de);
 buf:=copy(buf,p+1,999);
 p:=pos('m',buf);
 if p=0 then p:=pos('''',buf);
 de:=de+s*strtofloat(copy(buf,1,p-1))/60;
 buf:=copy(buf,p+1,999);
 p:=pos('s',buf);
 if p=0 then p:=pos('"',buf);
 if p=0 then p:=99;
 de:=de+s*strtofloat(copy(buf,1,p-1))/3600;
end else begin
 de:=strtofloat(param1);
end;
result:=msgOK;
if (de>=-90)and(de<=90) then sc.cfgsc.decentre:=deg2rad*de else result:=msgFailed+' DEC out of range';
except
exit;
end;
end;

function Tf_chart.cmd_GetRA(format:string):string;
begin
if format='F' then begin
 result:=msgOK+blank+formatfloat(f5,rad2deg*sc.cfgsc.racentre/15);
end else begin
 result:=msgOK+blank+artostr3(rad2deg*sc.cfgsc.racentre/15);
end
end;

function Tf_chart.cmd_GetDEC(format:string):string;
begin
if format='F' then begin
 result:=msgOK+blank+formatfloat(f5,rad2deg*sc.cfgsc.decentre);
end else begin
 result:=msgOK+blank+detostr3(rad2deg*sc.cfgsc.decentre);
end
end;

function Tf_chart.cmd_SetDate(dt:string):string;
var p,y,m,d,h,n,s : integer;
begin
result:=msgFailed+' Bad date format!';
try
dt:=trim(dt);
p:=pos('-',dt);
if p=0 then exit;
y:=strtoint(trim(copy(dt,1,p-1)));
dt:=copy(dt,p+1,999);
p:=pos('-',dt);
if p=0 then exit;
m:=strtoint(trim(copy(dt,1,p-1)));
dt:=copy(dt,p+1,999);
p:=pos('T',dt);
if p=0 then p:=pos(' ',dt);
if p=0 then exit;
d:=strtoint(trim(copy(dt,1,p-1)));
dt:=copy(dt,p+1,999);
p:=pos(':',dt);
if p=0 then exit;
h:=strtoint(trim(copy(dt,1,p-1)));
dt:=copy(dt,p+1,999);
p:=pos(':',dt);
if p=0 then exit;
n:=strtoint(trim(copy(dt,1,p-1)));
dt:=copy(dt,p+1,999);
s:=strtoint(trim(dt));
sc.cfgsc.UseSystemTime:=false;
result:=msgOK;
if (y>=-20000)and(y<=20000) then sc.cfgsc.CurYear:=y else result:=msgFailed+' Year out of range';
if (m>=1)and(m<=12) then sc.cfgsc.CurMonth:=m else result:=msgFailed+' Month out of range';
if (d>=1)and(d<=31) then sc.cfgsc.CurDay:=d else result:=msgFailed+' Day out of range';
if (h>=0)and(h<=23)and(n>=0)and(n<=59)and(s>=0)and(s<=59) then sc.cfgsc.CurTime:=h+n/60+s/3600 else result:=msgFailed+' Time out of range';
sc.cfgsc.tz.JD:=jd(sc.cfgsc.CurYear,sc.cfgsc.CurMonth,sc.cfgsc.CurDay,sc.cfgsc.CurTime);
sc.cfgsc.TimeZone:=sc.cfgsc.tz.SecondsOffset/3600;
if (not sc.cfgsc.TrackOn)and(sc.cfgsc.Projpole=Altaz) then begin
  sc.cfgsc.TrackOn:=true;
  sc.cfgsc.TrackType:=4;
end;
except
exit;
end;
end;

function Tf_chart.cmd_GetDate:string;
begin
result:=msgOK+blank+Date2Str(sc.cfgsc.CurYear,sc.cfgsc.curmonth,sc.cfgsc.curday)+'T'+ArToStr3(sc.cfgsc.Curtime);
end;

function Tf_chart.cmd_SetObs(obs:string):string;
var n,buf : string;
    p,tz : integer;
    s,la,lo,al : double;
begin
result:=msgFailed+' Bad observatory format!';
try
p:=pos('LAT:',obs);          
if p=0 then exit;
buf:=copy(obs,p+4,999);
p:=pos('d',buf);
la:=strtofloat(copy(buf,1,p-1));
s:=sgn(la);
buf:=copy(buf,p+1,999);
p:=pos('m',buf);
la:=la+s*strtofloat(copy(buf,1,p-1))/60;
buf:=copy(buf,p+1,999);
p:=pos('s',buf);
la:=la+s*strtofloat(copy(buf,1,p-1))/3600;
p:=pos('LON:',obs);
if p=0 then exit;
buf:=copy(obs,p+4,999);
p:=pos('d',buf);
lo:=strtofloat(copy(buf,1,p-1));
s:=sgn(lo);
buf:=copy(buf,p+1,999);
p:=pos('m',buf);
lo:=lo+s*strtofloat(copy(buf,1,p-1))/60;
buf:=copy(buf,p+1,999);
p:=pos('s',buf);
lo:=lo+s*strtofloat(copy(buf,1,p-1))/3600;
p:=pos('ALT:',obs);
if p=0 then exit;
buf:=copy(obs,p+4,999);
p:=pos('m',buf);
al:=strtofloat(copy(buf,1,p-1));
p:=pos('TZ:',obs);
if p>0 then begin
  buf:=copy(obs,p+3,999);
  p:=pos('h',buf);
  buf:=copy(buf,1,p-1);
  tz:=-StrToInt(buf);
  buf:=trim(inttostr(tz));
  if tz>0 then buf:='+'+buf;
  cmd_SetTZ('Etc/GMT'+buf);
  sc.cfgsc.countrytz:=false;
end;
p:=pos('OBS:',obs);
if p=0 then n:='obs?'
       else n:=trim(copy(obs,p+4,999));
result:=msgOK;
if (la>=-90)and(la<=90) then sc.cfgsc.ObsLatitude := la else result:=msgFailed+' Latitude out of range';
if (lo>=-180)and(lo<=180) then sc.cfgsc.ObsLongitude := lo else result:=msgFailed+' Longitude out of range';
if (al>=-500)and(al<=15000) then sc.cfgsc.ObsAltitude := al else result:=msgFailed+' Altitude out of range';
p:=pos('/',n);
if p>0 then begin
   sc.cfgsc.Obscountry:=trim(copy(n,1,p-1));
   delete(n,1,p);
end else sc.cfgsc.Obscountry:='';
sc.cfgsc.ObsName := n;
except
exit;
end;
end;

function Tf_chart.cmd_GetObs:string;
begin
result:=msgOK+blank+'LAT:'+detostr3(sc.cfgsc.ObsLatitude)+'LON:'+detostr3(sc.cfgsc.ObsLongitude)+'ALT:'+formatfloat(f0,sc.cfgsc.ObsAltitude)+'mOBS:'+sc.cfgsc.Obscountry+'/'+sc.cfgsc.ObsName;
end;

function Tf_chart.cmd_SetTZ(tz:string):string;
var buf:string;
begin
try
  buf:=ZoneDir+StringReplace(tz,'/',PathDelim,[rfReplaceAll]);
  if FileExists(buf) then begin
    sc.cfgsc.ObsTZ:=tz;
    sc.cfgsc.tz.TimeZoneFile:=buf;
    sc.cfgsc.TimeZone:=sc.cfgsc.tz.SecondsOffset/3600;
    result:=msgOK;
  end
  else result:=msgFailed+' invalid timezone: '+tz;
except
  result:=msgFailed;
end
end;

function Tf_chart.cmd_GetTZ:string;
begin
 result:=msgOK+blank+sc.cfgsc.ObsTZ;
end;

function Tf_chart.cmd_PDSS(DssDir,ImagePath,ImageName, useexisting: string):string;
var ra2000,de2000: double;
begin
f_getdss.cmain:=cmain;
ra2000:=sc.cfgsc.racentre;
de2000:=sc.cfgsc.decentre;
if sc.cfgsc.ApparentPos then mean_equatorial(ra2000,de2000,sc.cfgsc,true,true);
precession(sc.cfgsc.JDchart,jd2000,ra2000,de2000);
if f_getdss.GetDss(ra2000,de2000,sc.cfgsc.fov,sc.cfgsc.windowratio,image1.width) then begin
   sc.Fits.Filename:=expandfilename(f_getdss.cfgdss.dssfile);
   sc.Fits.InfoWCScoord;
   if sc.Fits.Header.valid then begin
      sc.Fits.DeleteDB('OTHER','BKG');
      if not sc.Fits.InsertDB(sc.Fits.Filename,'OTHER','BKG',sc.Fits.Center_RA,sc.Fits.Center_DE,sc.Fits.Img_Width,sc.Fits.Img_Height,sc.Fits.Rotation) then
             sc.Fits.InsertDB(sc.Fits.Filename,'OTHER','BKG',sc.Fits.Center_RA+0.00001,sc.Fits.Center_DE+0.00001,sc.Fits.Img_Width,sc.Fits.Img_Height,sc.Fits.Rotation);
      sc.cfgsc.TrackOn:=true;
      sc.cfgsc.TrackType:=5;
      sc.cfgsc.BackgroundImage:=sc.Fits.Filename;
      sc.cfgsc.ShowBackgroundImage:=true;
      Refresh;
      result:=msgOK;
   end;
end;
end;

function Tf_chart.cmd_IdentCursor:string;
begin
if identxy(xcursor,ycursor) then result:=msgOK
   else result:=msgFailed+' No object found!';
end;

Function Tf_chart.cmd_IdXY(xx,yy : string): string;
var x,y,p : integer;
    buf : string;
begin
p:=pos('X:',xx);
if p=0 then buf:=xx
       else buf:=copy(xx,p+2,999);
x:=strtoint(trim(buf));
p:=pos('Y:',yy);
if p=0 then buf:=yy
       else buf:=copy(yy,p+2,999);
y:=strtoint(trim(buf));
if identxy(x,y) then result:=msgOK
   else result:=msgFailed+' No object found!';
end;

Procedure Tf_chart.cmd_GoXY(xx,yy : string);
var x,y,p : integer;
    buf:string;
begin
p:=pos('X:',xx);
if p=0 then buf:=xx
       else buf:=copy(xx,p+2,999);
x:=strtoint(trim(buf));
p:=pos('Y:',yy);
if p=0 then buf:=yy
       else buf:=copy(yy,p+2,999);
y:=strtoint(trim(buf));
sc.MovetoXY(x,y);
end;

function Tf_chart.cmd_Print(Method,Orient,Col,path:string):string;
var PrintMethod,printcolor: integer;
    ok,printlandscape:boolean;
    PrintTmpPath: string;
begin
ok:=true;
Method:=UpperCase(Trim(Method));
if Method='' then PrintMethod:=cmain.PrintMethod
else if Method='PRT' then PrintMethod:=0
else if Method='PS' then PrintMethod:=1
else if Method='BMP' then PrintMethod:=2
else ok:=false;
Orient:=UpperCase(Trim(Orient));
if Orient='' then printlandscape:=cmain.printlandscape
else if Orient='PORTRAIT' then printlandscape:=false
else if Orient='LANDSCAPE' then printlandscape:=true
else ok:=false;
Col:=UpperCase(Trim(Col));
if Col='' then printcolor:=cmain.printcolor
else if Col='COLOR' then printcolor:=0
else if Col='BW' then printcolor:=1
else ok:=false;
if path='' then PrintTmpPath:=cmain.PrintTmpPath
   else PrintTmpPath:=path;
if ok then PrintChart(printlandscape,printcolor,PrintMethod,cmain.PrinterResolution,cmain.PrintCmd1,cmain.PrintCmd2,PrintTmpPath,cmain,false);
if ok then result:=msgOK
   else result:=msgFailed;
end;

function Tf_chart.cmd_SaveImage(format,fn,quality:string):string;
var i : integer;
begin
i:=strtointdef(quality,95);
if SaveChartImage(format,fn,i) then result:=msgOK
   else result:=msgFailed;
end;

procedure Tf_chart.cmd_MoreStar;
begin
{$ifdef trace_debug}
 WriteTrace(caption+' cmd_MoreStar');
{$endif}
if sc.catalog.cfgshr.AutoStarFilter then
   sc.catalog.cfgshr.AutoStarFilterMag:=min(16,sc.catalog.cfgshr.AutoStarFilterMag+0.5)
else begin
  sc.catalog.cfgshr.StarMagFilter[sc.cfgsc.FieldNum]:=sc.catalog.cfgshr.StarMagFilter[sc.cfgsc.FieldNum]+0.5;
  if sc.catalog.cfgshr.StarMagFilter[sc.cfgsc.FieldNum]>sc.plot.cfgchart.max_catalog_mag then sc.catalog.cfgshr.StarMagFilter[sc.cfgsc.FieldNum]:=99;
end;
refresh;
end;

procedure Tf_chart.cmd_LessStar;
begin
{$ifdef trace_debug}
 WriteTrace(caption+' cmd_LessStar');
{$endif}
if sc.catalog.cfgshr.AutoStarFilter then
   sc.catalog.cfgshr.AutoStarFilterMag:=max(1,sc.catalog.cfgshr.AutoStarFilterMag-0.5)
else begin
   if sc.catalog.cfgshr.StarMagFilter[sc.cfgsc.FieldNum]>=99 then sc.catalog.cfgshr.StarMagFilter[sc.cfgsc.FieldNum]:=sc.plot.cfgchart.min_ma
      else sc.catalog.cfgshr.StarMagFilter[sc.cfgsc.FieldNum]:=max(1,sc.catalog.cfgshr.StarMagFilter[sc.cfgsc.FieldNum]-0.5);
end;
refresh;
end;

procedure Tf_chart.cmd_MoreNeb;
begin
{$ifdef trace_debug}
 WriteTrace(caption+' cmd_MoreNeb');
{$endif}
sc.catalog.cfgshr.NebMagFilter[sc.cfgsc.FieldNum]:=sc.catalog.cfgshr.NebMagFilter[sc.cfgsc.FieldNum]+0.5;
if sc.catalog.cfgshr.NebMagFilter[sc.cfgsc.FieldNum]>15 then sc.catalog.cfgshr.NebMagFilter[sc.cfgsc.FieldNum]:=99;
sc.catalog.cfgshr.NebSizeFilter[sc.cfgsc.FieldNum]:=sc.catalog.cfgshr.NebSizeFilter[sc.cfgsc.FieldNum]/1.5;
if sc.catalog.cfgshr.NebSizeFilter[sc.cfgsc.FieldNum]<0.1 then sc.catalog.cfgshr.NebSizeFilter[sc.cfgsc.FieldNum]:=0;
refresh;
end;

procedure Tf_chart.cmd_LessNeb;
begin
{$ifdef trace_debug}
 WriteTrace(caption+' cmd_LessNeb');
{$endif}
if sc.catalog.cfgshr.NebMagFilter[sc.cfgsc.FieldNum]>=99 then sc.catalog.cfgshr.NebMagFilter[sc.cfgsc.FieldNum]:=20
   else sc.catalog.cfgshr.NebMagFilter[sc.cfgsc.FieldNum]:=sc.catalog.cfgshr.NebMagFilter[sc.cfgsc.FieldNum]-0.5;
if sc.catalog.cfgshr.NebMagFilter[sc.cfgsc.FieldNum]<6 then sc.catalog.cfgshr.NebMagFilter[sc.cfgsc.FieldNum]:=6;
if sc.catalog.cfgshr.NebSizeFilter[sc.cfgsc.FieldNum]<=0 then sc.catalog.cfgshr.NebSizeFilter[sc.cfgsc.FieldNum]:=0.1
   else sc.catalog.cfgshr.NebSizeFilter[sc.cfgsc.FieldNum]:=sc.catalog.cfgshr.NebSizeFilter[sc.cfgsc.FieldNum]*1.5;
if sc.catalog.cfgshr.NebSizeFilter[sc.cfgsc.FieldNum]>100 then sc.catalog.cfgshr.NebSizeFilter[sc.cfgsc.FieldNum]:=100;
refresh;
end;

function Tf_chart.ExecuteCmd(arg:Tstringlist):string;
var i,n : integer;
    cmd : string;
begin
cmd:=trim(uppercase(arg[0]));
{$ifdef trace_debug}
 WriteTrace(caption+' ExecuteCmd '+cmd);
{$endif}
n:=-1;
for i:=1 to numcmd do
   if cmd=cmdlist[i,1] then begin
      n:=strtointdef(cmdlist[i,2],-1);
      break;
   end;
result:=msgOK;
case n of
 1 : sc.zoom(zoomfactor);
 2 : sc.zoom(1/zoomfactor);
 3 : sc.MoveChart(0,1,movefactor);
 4 : sc.MoveChart(0,-1,movefactor);
 5 : sc.MoveChart(1,0,movefactor);
 6 : sc.MoveChart(-1,0,movefactor);
 7 : sc.MoveChart(1,1,movefactor);
 8 : sc.MoveChart(1,-1,movefactor);
 9 : sc.MoveChart(-1,1,movefactor);
 10 : sc.MoveChart(-1,-1,movefactor);
 11 : begin sc.cfgsc.FlipX:=-sc.cfgsc.FlipX; if sc.cfgsc.FlipX<0 then sc.cfgsc.FlipY:=1; if assigned(FUpdateBtn) then FUpdateBtn(sc.cfgsc.flipx,sc.cfgsc.flipy,Connect1.checked,self);end;
 12 : begin sc.cfgsc.FlipY:=-sc.cfgsc.FlipY; if sc.cfgsc.FlipY<0 then sc.cfgsc.FlipX:=1; if assigned(FUpdateBtn) then FUpdateBtn(sc.cfgsc.flipx,sc.cfgsc.flipy,Connect1.checked,self);end;
 13 : result:=cmd_SetCursorPosition(strtointdef(arg[1],-1),strtointdef(arg[2],-1));
 14 : sc.MovetoXY(xcursor,ycursor);
 15 : begin sc.zoom(zoomfactor);sc.MovetoXY(xcursor,ycursor);end;
 16 : begin sc.zoom(1/zoomfactor);sc.MovetoXY(xcursor,ycursor);end;
 17 : sc.cfgsc.theta:=sc.cfgsc.theta+deg2rad*15;
 18 : sc.cfgsc.theta:=sc.cfgsc.theta-deg2rad*15;
 19 : result:=cmd_SetGridEQ(arg[1]);
 20 : result:=cmd_SetGrid(arg[1]);
 21 : result:=cmd_SetStarMode(strtointdef(arg[1],-1));
 22 : result:=cmd_SetNebMode(strtointdef(arg[1],-1));
 23 : result:=cmd_SetSkyMode(arg[1]);
 24 : UndoExecute(self);
 25 : RedoExecute(self);
 26 : result:=cmd_SetProjection(arg[1]);
 27 : result:=cmd_SetFov(arg[1]);
 28 : result:=cmd_SetRa(arg[1]);
 29 : result:=cmd_SetDec(arg[1]);
 30 : result:=cmd_SetObs(arg[1]+arg[2]+arg[3]+arg[4]+arg[5]+arg[6]+arg[7]+arg[8]);
 31 : result:=cmd_IdentCursor;
 32 : result:=cmd_SaveImage(arg[1],arg[2],arg[3]);
 33 : SetAz(deg2rad*180,false);
 34 : SetAz(0,false);
 35 : SetAz(deg2rad*270,false);
 36 : SetAz(deg2rad*90,false);
 37 : SetZenit(0,false);
 38 : SetZenit(deg2rad*200,false);
 39 : Refresh;
 40 : result:=cmd_GetCursorPosition;
 41 : result:=cmd_GetGridEQ;
 42 : result:=cmd_GetGrid;
 43 : result:=cmd_GetStarMode;
 44 : result:=cmd_GetNebMode;
 45 : result:=cmd_GetSkyMode;
 46 : result:=cmd_GetProjection;
 47 : result:=cmd_GetFov(arg[1]);
 48 : result:=cmd_GetRA(arg[1]);
 49 : result:=cmd_GetDEC(arg[1]);
 50 : result:=cmd_GetDate;
 51 : result:=cmd_GetObs;
 52 : begin result:=cmd_SetDate(arg[1]); Refresh; end;
 53 : begin result:=cmd_SetTZ(arg[1]); Refresh; end;
 54 : result:=cmd_GetTZ;
 55 : begin cmd_SetRa(arg[1]); cmd_SetDec(arg[2]); cmd_SetFov(arg[3]); Refresh; end;
 56 : begin PDSSTimer.Enabled:=true; result:=msgOK;end;// result:=cmd_PDSS(arg[1],arg[2],arg[3],arg[4]);
 57 : result:=cmd_SaveImage('BMP',arg[1],'');
 58 : result:=cmd_SaveImage('GIF',arg[1],'');
 59 : result:=cmd_SaveImage('JPEG',arg[1],arg[2]);
 60 : result:=cmd_IdXY(arg[1],arg[2]);
 61 : cmd_GoXY(arg[1],arg[2]);
 62 : cmd_MoreStar;
 63 : cmd_LessStar;
 64 : cmd_MoreNeb;
 65 : cmd_LessNeb;
 66 : GridEQExecute(Self);
 67 : GridExecute(Self);
 68 : begin result:=cmd_SwitchGridNum; Refresh; end;
 69 : begin result:=cmd_SwitchConstL; Refresh; end;
 70 : begin result:=cmd_SwitchConstB; Refresh; end;
 71 : begin if sc.cfgsc.projpole<>equat then sc.cfgsc.projpole:=equat else sc.cfgsc.projpole:=altaz; refresh; end;
 77 : result:=cmd_SetGridNum(arg[1]);
 78 : result:=cmd_SetConstL(arg[1]);
 79 : result:=cmd_SetConstB(arg[1]);
 80 : result:=cmd_resize(arg[1],arg[2]);
 81 : result:=cmd_print(arg[1],arg[2],arg[3],arg[4]);
else result:=msgFailed+' Bad command name';
end;
end;

procedure Tf_chart.FormKeyPress(Sender: TObject; var Key: Char);
begin
if lockkey then exit;
{$ifdef trace_debug}
 WriteTrace(caption+' FormKeyPress '+Key);
{$endif}
lockkey:=true;
try
case key of
#17 : if sc.plot.cfgplot.partsize<=4.8 then begin  // ctrl+q
       sc.plot.cfgplot.partsize:=sc.plot.cfgplot.partsize+0.2;
       Refresh;
     end;
#1 : if sc.plot.cfgplot.partsize>=0.3 then begin  // ctrl+a
       sc.plot.cfgplot.partsize:=sc.plot.cfgplot.partsize-0.2;
       Refresh;
     end;
#23 : if sc.plot.cfgplot.magsize<=9.5  then begin   // ctrl+w
       sc.plot.cfgplot.magsize:=sc.plot.cfgplot.magsize+0.5;
       Refresh;
     end;
#19 : if sc.plot.cfgplot.magsize>=1.5   then begin   // ctrl+s
       sc.plot.cfgplot.magsize:=sc.plot.cfgplot.magsize-0.5;
       Refresh;
     end;
#5  : if sc.plot.cfgplot.contrast<=980 then begin   // ctrl+e
       sc.plot.cfgplot.contrast:=sc.plot.cfgplot.contrast+20;
       Refresh;
     end;
#4  : if sc.plot.cfgplot.contrast>=120  then begin   // ctrl+d
       sc.plot.cfgplot.contrast:=sc.plot.cfgplot.contrast-20;
       Refresh;
     end;
#18 : if sc.plot.cfgplot.saturation<=250 then begin  // ctrl+r
       sc.plot.cfgplot.saturation:=sc.plot.cfgplot.saturation+20;
       Refresh;
     end;
#6  : if sc.plot.cfgplot.saturation>=5 then begin  // ctrl+f
       sc.plot.cfgplot.saturation:=sc.plot.cfgplot.saturation-20;
       Refresh;
     end;
'+' : Zoomplus.execute;
'-' : Zoomminus.execute;
'1' : SetField(deg2rad*sc.catalog.cfgshr.FieldNum[0]);
'2' : SetField(deg2rad*sc.catalog.cfgshr.FieldNum[1]);
'3' : SetField(deg2rad*sc.catalog.cfgshr.FieldNum[2]);
'4' : SetField(deg2rad*sc.catalog.cfgshr.FieldNum[3]);
'5' : SetField(deg2rad*sc.catalog.cfgshr.FieldNum[4]);
'6' : SetField(deg2rad*sc.catalog.cfgshr.FieldNum[5]);
'7' : SetField(deg2rad*sc.catalog.cfgshr.FieldNum[6]);
'8' : SetField(deg2rad*sc.catalog.cfgshr.FieldNum[7]);
'9' : SetField(deg2rad*sc.catalog.cfgshr.FieldNum[8]);
'0' : SetField(deg2rad*sc.catalog.cfgshr.FieldNum[9]);
'a' : SetZenit(deg2rad*200);
'e' : SetAz(deg2rad*270);
'n' : SetAz(deg2rad*180);
's' : SetAz(0);
'w' : SetAz(deg2rad*90);
'z' : SetZenit(0);
'C' : SetCameraRotation(1);
'G' : SetCameraRotation(2);
'S' : SetCameraRotation(0);
end;
Application.ProcessMessages;
finally
lockkey:=false;
end;
end;

procedure Tf_chart.SetField(field : double);
begin
sc.setfov(field);
{$ifdef trace_debug}
 WriteTrace(caption+' SetField');
{$endif}
Refresh;
end;

procedure Tf_chart.SetZenit(field : double; redraw:boolean=true);
var a,d,az : double;
begin
{$ifdef trace_debug}
 WriteTrace(caption+' SetZenit');
{$endif}
az:=sc.cfgsc.acentre;
if field>0 then begin
  if sc.cfgsc.windowratio>1  then sc.cfgsc.fov:=field*sc.cfgsc.windowratio
     else sc.cfgsc.fov:=field;
end;
sc.cfgsc.ProjPole:=Altaz;
sc.cfgsc.Acentre:=0;
sc.cfgsc.hcentre:=pid2;
Hz2Eq(sc.cfgsc.acentre,sc.cfgsc.hcentre,a,d,sc.cfgsc);
sc.cfgsc.racentre:=sc.cfgsc.CurST-a;
sc.cfgsc.decentre:=d;
sc.cfgsc.TrackOn:=false;
if field>0 then begin
   setaz(az,redraw);
   end
else if redraw then Refresh;
end;

procedure Tf_chart.SetAz(Az : double; redraw:boolean=true);
var a,d : double;
begin
{$ifdef trace_debug}
 WriteTrace(caption+' SetAz');
{$endif}
a := minvalue([sc.cfgsc.Fov,sc.cfgsc.Fov/sc.cfgsc.windowratio]);
if sc.cfgsc.Fov<pi then Hz2Eq(Az,a/2.3,a,d,sc.cfgsc)
                   else Hz2Eq(Az,sc.cfgsc.hcentre,a,d,sc.cfgsc);
sc.cfgsc.acentre:=Az;
sc.cfgsc.racentre:=sc.cfgsc.CurST-a;
sc.cfgsc.decentre:=d;
sc.cfgsc.ProjPole:=Altaz;
sc.cfgsc.TrackOn:=false;
if redraw then Refresh;
end;

procedure Tf_chart.SetDateUT(y,m,d,h,n,s:integer);
var jj,hh,sn: double;
begin
sn:=sign(h);
hh:=h+sn*n/60+sn*s/3600;
jj:=jd(y,m,d,hh);
SetJD(jj);
end;

procedure Tf_chart.SetJD(njd:double);
var y,m,d : integer;
    h : double;
begin
if (njd>maxjd)or(njd<minjd) then exit;
sc.cfgsc.tz.JD:=njd;
sc.cfgsc.TimeZone:=sc.cfgsc.tz.SecondsOffset/3600;
djd(njd+(sc.cfgsc.TimeZone-sc.cfgsc.DT_UT)/24,y,m,d,h);
sc.cfgsc.UseSystemTime:=false;
sc.cfgsc.CurYear:=y;
sc.cfgsc.CurMonth:=m;
sc.cfgsc.CurDay:=d;
sc.cfgsc.CurTime:=h;
if (not sc.cfgsc.TrackOn)and(sc.cfgsc.Projpole=Altaz) then begin
  sc.cfgsc.TrackOn:=true;
  sc.cfgsc.TrackType:=4;
end;
{$ifdef trace_debug}
 WriteTrace(caption+' SetJD');
{$endif}
Refresh;
end;

procedure Tf_chart.IdentDetail(X, Y: Integer);
var ra,dec,a,h,l,b,le,be,dx:double;
begin
if locked then exit;
sc.GetCoord(x,y,ra,dec,a,h,l,b,le,be);
ra:=rmod(ra+pi2,pi2);
dx:=1/sc.cfgsc.BxGlb; // search a 1 pixel radius
sc.FindatRaDec(ra,dec,dx,true);
if sc.cfgsc.FindDesc>'' then begin
   if assigned(Fshowinfo) then Fshowinfo(sc.cfgsc.FindDesc,caption,true,self,sc.cfgsc.FindDesc2);
   identlabelClick(Self);
end;   
end;


procedure Tf_chart.Connect1Click(Sender: TObject);
// Connect Telescope
begin
{$ifdef trace_debug}
 WriteTrace(caption+' Connect Telescope');
{$endif}
if sc.cfgsc.ASCOMTelescope then begin
   ConnectASCOM(Sender);
end
else
if sc.cfgsc.LX200Telescope then begin
   ConnectLX200(Sender);
end
else if sc.cfgsc.EncoderTelescope then begin
   ConnectEncoder(Sender);
end
else if sc.cfgsc.ManualTelescope then begin
   sc.cfgsc.TelescopeJD:=0;
end
else if sc.cfgsc.IndiTelescope then begin
   ConnectINDI(Sender);
end;
if (not sc.cfgsc.TrackOn) then sc.cfgsc.TrackName:=rsTelescope;
end;

procedure Tf_chart.Slew1Click(Sender: TObject);
begin
if Connect1.checked then begin
  if sc.cfgsc.ASCOMTelescope then begin
     SlewASCOM(Sender);
  end
  else
  if sc.cfgsc.LX200Telescope then begin
   SlewLX200(Sender);
  end
  else if sc.cfgsc.EncoderTelescope then begin
   // no slew
  end
  else if sc.cfgsc.IndiTelescope then begin
    SlewINDI(Sender);
  end;
end
else if assigned(Fshowinfo) then Fshowinfo(rsTelescopeNot);
end;

procedure Tf_chart.AbortSlew1Click(Sender: TObject);
begin
if Connect1.checked then begin
  if sc.cfgsc.ASCOMTelescope then begin
     AbortSlewASCOM(Sender);
  end
else
if sc.cfgsc.LX200Telescope then begin
 AbortSlewLX200(Sender);
end
else if sc.cfgsc.EncoderTelescope then begin
   // no slew
  end
else if sc.cfgsc.IndiTelescope then
begin
  AbortSlewINDI(Sender);
end;
end;
end;

procedure Tf_chart.Sync1Click(Sender: TObject);
begin
if Connect1.checked and
   (mrYes=MessageDlg(Format(rsPleaseConfir, [sc.cfgsc.FindName]),
     mtConfirmation, [mbYes, mbNo], 0))
then begin
if sc.cfgsc.ASCOMTelescope then begin
   SyncASCOM(Sender);
end
else
if sc.cfgsc.LX200Telescope then begin
 SyncLX200(Sender);
end
else if sc.cfgsc.EncoderTelescope then begin
   SyncEncoder(Sender);
end
else if sc.cfgsc.IndiTelescope then begin
   SyncINDI(Sender);
end;
end
else if assigned(Fshowinfo) then Fshowinfo(rsTelescopeNot);
end;

procedure Tf_chart.NewFinderCircle1Click(Sender: TObject);
  begin
  if MovingCircle or (sc.cfgsc.NumCircle>=MaxCircle) then exit;
  mouse.CursorPos:=point(xcursor+Image1.ClientOrigin.x,ycursor+Image1.ClientOrigin.y);
  GetAdXy(Xcursor,Ycursor,sc.cfgsc.CircleLst[0,1],sc.cfgsc.CircleLst[0,2],sc.cfgsc);
  sc.DrawFinderMark(sc.cfgsc.CircleLst[0,1],sc.cfgsc.CircleLst[0,2],true,-1);
  MovingCircle := true;
  StartCircle:=true;
end;

procedure Tf_chart.RemoveLastCircle1Click(Sender: TObject);
begin
if sc.cfgsc.NumCircle>0 then dec(sc.cfgsc.NumCircle);
{$ifdef trace_debug}
 WriteTrace(caption+' RemoveLastCircle1Click');
{$endif}
Refresh;
end;

procedure Tf_chart.RemoveAllCircles1Click(Sender: TObject);
begin
sc.cfgsc.NumCircle:=0;
{$ifdef trace_debug}
 WriteTrace(caption+' RemoveAllCircles1Click');
{$endif}
Refresh;
end;

procedure Tf_chart.MenuSaveCircleClick(Sender: TObject);
var f: textfile;
    i: integer;
begin
if SaveDialog1.InitialDir='' then SaveDialog1.InitialDir:=HomeDir;
if (sc.cfgsc.NumCircle>0) and SaveDialog1.Execute then begin
  {$ifdef trace_debug}
   WriteTrace(caption+' Save Circles to '+UTF8ToSys(SaveDialog1.FileName));
  {$endif}
   AssignFile(f,UTF8ToSys(SaveDialog1.FileName));
   Rewrite(f);
   for i:=1 to sc.cfgsc.NumCircle do begin
     WriteLn(f,'Circle_'+FormatFloat('00',i)+blank+ARToStr3(rad2deg*sc.cfgsc.CircleLst[i,1]/15)+blank+DEToStr3(rad2deg*sc.cfgsc.CircleLst[i,2]));
   end;
   CloseFile(f);
end;
end;

procedure Tf_chart.PDSSTimerTimer(Sender: TObject);
begin
  PDSSTimer.Enabled:=false;
  cmd_PDSS('','','','');
end;

procedure Tf_chart.MenuLoadCircleClick(Sender: TObject);
var f: textfile;
    buf1,buf2: string;
    x: double;
begin
if OpenDialog1.InitialDir='' then OpenDialog1.InitialDir:=HomeDir;
if OpenDialog1.Execute then begin
  {$ifdef trace_debug}
   WriteTrace(caption+' Load Circles from '+UTF8ToSys(OpenDialog1.FileName));
  {$endif}
  AssignFile(f,UTF8ToSys(OpenDialog1.FileName));
  reset(f);
  sc.cfgsc.NumCircle:=0;
  repeat
     ReadLn(f,buf1);
     inc(sc.cfgsc.NumCircle);
     if sc.cfgsc.NumCircle>=MaxCircle then break;
     buf2:=words(buf1,blank,2,1);
     x:=deg2rad*15*Str3ToAR(trim(buf2));
     if x=0 then begin dec(sc.cfgsc.NumCircle); continue; end;
     sc.cfgsc.CircleLst[sc.cfgsc.NumCircle,1]:=x;
     buf2:=words(buf1,blank,3,1);
     x:=deg2rad*Str3ToDE(trim(buf2));
     if x=0 then begin dec(sc.cfgsc.NumCircle); continue; end;
     sc.cfgsc.CircleLst[sc.cfgsc.NumCircle,2]:=x;
  until eof(f);
  CloseFile(f);
  Refresh;
end;
end;

procedure Tf_chart.SetNightVision(value:boolean);
var i:integer;
begin
if value=FNightVision then exit;
FNightVision:=value;
if FNightVision then begin
   SaveColor:=sc.plot.cfgplot.color;
   for i:=1 to numlabtype do SaveLabelColor[i]:=sc.plot.cfgplot.labelcolor[i];
   sc.plot.cfgplot.color:=DfRedColor;
   for i:=1 to numlabtype do sc.plot.cfgplot.labelcolor[i]:=$000000A0;
   {$ifdef mswindows}
     Panel1.Color:=nv_dark;
   {$endif}
end else begin
   if (Savecolor[2]=DfRedColor[2])and(Savecolor[11]=DfRedColor[11]) then begin // started with night vision, return to default color as save is also red. 
      sc.plot.cfgplot.color:=DfColor;
      for i:=1 to numlabtype do sc.plot.cfgplot.labelcolor[i]:=clWhite;
      sc.plot.cfgplot.labelcolor[6]:=clYellow;
   end else begin
      sc.plot.cfgplot.color:=SaveColor;
      for i:=1 to numlabtype do sc.plot.cfgplot.labelcolor[i]:=SaveLabelColor[i];
   end;
   {$ifdef mswindows}
     Panel1.Color:=clBtnFace;
   {$endif}
end;
Refresh;
end;


function Tf_chart.SaveChartImage(format,fn : string; quality : integer=95):boolean;
var
   JPG : TJpegImage;
   PNG : TPortableNetworkGraphic;
   savelabel,needrefresh:boolean;
   curdir:string;
begin
result:=false;
try
needrefresh:=false;
savelabel:= sc.cfgsc.Editlabels;
format:=uppercase(format);
{$ifdef trace_debug}
 WriteTrace(caption+' SaveChartImage');
{$endif}
try
if savelabel then begin
   sc.cfgsc.Editlabels:=false;
   sc.Refresh;
   needrefresh:=true;
end;
if identlabel.Visible then begin
  sc.plot.cnv:=sc.plot.cbmp.Canvas;
  sc.plot.PlotText(identlabel.Left,identlabel.Top,2,identlabel.Font.Color,laLeft,laTop,identlabel.Caption,sc.cfgsc.WhiteBg);
  needrefresh:=true;
end;
 if fn='' then fn:='cdc.bmp';
 if format='' then format:='BMP';
 curdir:=getcurrentdir;
 chdir(TempDir);
 fn:=ExpandFileName(fn);
 chdir(curdir);
 if format='PNG' then begin
    fn:=changefileext(fn,'.png');
    PNG := TPortableNetworkGraphic.Create;
    try
    // Convert the bitmap to PNG
    PNG.Assign(sc.plot.cbmp);
    // Save the PNG
    PNG.SaveToFile(fn);
    result:=true;
    finally
    PNG.Free;
    end;
    end
 else if format='JPEG' then begin
    fn:=changefileext(fn,'.jpg');
    JPG := TJpegImage.Create;
    try
    // Convert the bitmap to a Jpeg
    JPG.Assign(sc.plot.cbmp);
    JPG.CompressionQuality:=quality;
    // Save the Jpeg
    JPG.SaveToFile(fn);
    result:=true;
    finally
    JPG.Free;
    end;
    end
 else if format='BMP' then begin
    fn:=changefileext(fn,'.bmp');
    sc.plot.cbmp.savetofile(fn);
    result:=true;
    end
 else result:=false;
finally
if savelabel then begin
   sc.cfgsc.Editlabels:=true;
end;
if needrefresh then begin
   sc.Refresh;
   SetScrollBar;
end;
end;
except
  on E: Exception do begin
   WriteTrace('Saveimg error: '+E.Message);
   result:=false;
  end;
end;
end;

// INDI interface

procedure Tf_chart.ConnectINDI(Sender: TObject);
begin
if Fpop_indi=nil then begin
  Fpop_indi:=Tpop_indi.Create(self);
  Fpop_indi.csc:=sc.cfgsc;
  Fpop_indi.SetLang;
end;
if Connect1.checked then begin
   Fpop_indi.ScopeShow;
end else begin
     Fpop_indi.ScopeReadConfig(ExtractFilePath(Configfile));
     Fpop_indi.ScopeSetObs(sc.cfgsc.ObsLatitude,sc.cfgsc.ObsLongitude);
     Fpop_indi.ScopeShow;
     TelescopeTimer.Interval:=2000;
     TelescopeTimer.Enabled:=true;
end;
if assigned(FUpdateBtn) then FUpdateBtn(sc.cfgsc.flipx,sc.cfgsc.flipy,Connect1.checked,self);
end;

procedure Tf_chart.SlewINDI(Sender: TObject);
var ra,dec:double;
    ok:boolean;
begin
ra:=sc.cfgsc.FindRA;
dec:=sc.cfgsc.FindDec;
if sc.cfgsc.TelescopeJD=0 then begin
  precession(sc.cfgsc.JDChart,sc.cfgsc.CurJD,ra,dec);
end else begin
  if sc.cfgsc.ApparentPos then mean_equatorial(ra,dec,sc.cfgsc,true,sc.cfgsc.FindType<ftPla);
  precession(sc.cfgsc.JDChart,sc.cfgsc.TelescopeJD,ra,dec);
end;
ra:=rmod(ra+pi2,pi2);
Fpop_indi.ScopeGoto(ra*rad2deg/15,dec*rad2deg,ok);
end;

procedure Tf_chart.AbortSlewINDI(Sender: TObject);
begin
Fpop_indi.ScopeAbortSlew;
end;

procedure Tf_chart.SyncINDI(Sender: TObject);
var ra,dec:double;
begin
ra:=sc.cfgsc.FindRA;
dec:=sc.cfgsc.FindDec;
if sc.cfgsc.TelescopeJD=0 then begin
   precession(sc.cfgsc.JDChart,sc.cfgsc.CurJD,ra,dec);
end else begin
   if sc.cfgsc.ApparentPos then mean_equatorial(ra,dec,sc.cfgsc,true,sc.cfgsc.FindType<ftPla);
   precession(sc.cfgsc.JDChart,sc.cfgsc.TelescopeJD,ra,dec);
end;
ra:=rmod(ra+pi2,pi2);
Fpop_indi.ScopeAlign(sc.cfgsc.FindName,ra*rad2deg/15,dec*rad2deg);
end;

// LX200 interface

procedure Tf_chart.ConnectLX200(Sender: TObject);
begin
if Fpop_lx200=nil then begin
  Fpop_lx200:=Tpop_lx200.Create(self);
  Fpop_lx200.csc:=sc.cfgsc;
  Fpop_lx200.SetLang;
end;
if Connect1.checked then begin
   Fpop_lx200.ScopeShow;
end else begin
     Fpop_lx200.ScopeReadConfig(ExtractFilePath(Configfile));
     Fpop_lx200.ScopeSetObs(sc.cfgsc.ObsLatitude,sc.cfgsc.ObsLongitude);
     Fpop_lx200.ScopeShow;
     TelescopeTimer.Interval:=2000;
     TelescopeTimer.Enabled:=true;
end;
if assigned(FUpdateBtn) then FUpdateBtn(sc.cfgsc.flipx,sc.cfgsc.flipy,Connect1.checked,self);
end;

procedure Tf_chart.SlewLX200(Sender: TObject);
var ra,dec:double;
    ok:boolean;
begin
ra:=sc.cfgsc.FindRA;
dec:=sc.cfgsc.FindDec;
if sc.cfgsc.TelescopeJD=0 then begin
  precession(sc.cfgsc.JDChart,sc.cfgsc.CurJD,ra,dec);
end else begin
  if sc.cfgsc.ApparentPos then mean_equatorial(ra,dec,sc.cfgsc,true,sc.cfgsc.FindType<ftPla);
  precession(sc.cfgsc.JDChart,sc.cfgsc.TelescopeJD,ra,dec);
end;
ra:=rmod(ra+pi2,pi2);
Fpop_lx200.ScopeGoto(ra*rad2deg/15,dec*rad2deg,ok);
end;

procedure Tf_chart.AbortSlewLX200(Sender: TObject);
begin
Fpop_lx200.ScopeAbortSlew;
end;

procedure Tf_chart.SyncLX200(Sender: TObject);
var ra,dec:double;
begin
ra:=sc.cfgsc.FindRA;
dec:=sc.cfgsc.FindDec;
if sc.cfgsc.TelescopeJD=0 then begin
   precession(sc.cfgsc.JDChart,sc.cfgsc.CurJD,ra,dec);
end else begin
   if sc.cfgsc.ApparentPos then mean_equatorial(ra,dec,sc.cfgsc,true,sc.cfgsc.FindType<ftPla);
   precession(sc.cfgsc.JDChart,sc.cfgsc.TelescopeJD,ra,dec);
end;
ra:=rmod(ra+pi2,pi2);
Fpop_lx200.ScopeAlign(sc.cfgsc.FindName,ra*rad2deg/15,dec*rad2deg);
end;

// Encoder interface

procedure Tf_chart.ConnectEncoder(Sender: TObject);
begin
if Fpop_encoder=nil then begin
  Fpop_encoder:=Tpop_encoder.Create(self);
  Fpop_encoder.csc:=sc.cfgsc;
  Fpop_encoder.SetLang;
end;
if Connect1.checked then begin
   Fpop_encoder.ScopeShow;
end else begin
     Fpop_encoder.ScopeReadConfig(ExtractFilePath(Configfile));
     Fpop_encoder.ScopeSetObs(sc.cfgsc.ObsLatitude,sc.cfgsc.ObsLongitude);
     Fpop_encoder.ScopeShow;
     TelescopeTimer.Interval:=2000;
     TelescopeTimer.Enabled:=true;
end;
if assigned(FUpdateBtn) then FUpdateBtn(sc.cfgsc.flipx,sc.cfgsc.flipy,Connect1.checked,self);
end;

procedure Tf_chart.SyncEncoder(Sender: TObject);
var ra,dec:double;
begin
ra:=sc.cfgsc.FindRA;
dec:=sc.cfgsc.FindDec;
if sc.cfgsc.TelescopeJD=0 then begin
   precession(sc.cfgsc.JDChart,sc.cfgsc.CurJD,ra,dec);
end else begin
   if sc.cfgsc.ApparentPos then mean_equatorial(ra,dec,sc.cfgsc,true,sc.cfgsc.FindType<ftPla);
   precession(sc.cfgsc.JDChart,sc.cfgsc.TelescopeJD,ra,dec);
end;
ra:=rmod(ra+pi2,pi2);
Fpop_encoder.ScopeAlign(sc.cfgsc.FindName,ra*rad2deg/15,dec*rad2deg);
end;


// Windows only ASCOM interface

procedure Tf_chart.ConnectASCOM(Sender: TObject);
begin
if Fpop_scope=nil then begin
  Fpop_scope:=Tpop_scope.Create(self);
  Fpop_scope.SetLang;
end;
if Connect1.checked then begin
   Fpop_scope.ScopeShow;
end else begin
     Fpop_scope.ScopeReadConfig(ExtractFilePath(Configfile));
     Fpop_scope.ScopeSetObs(sc.cfgsc.ObsLatitude,sc.cfgsc.ObsLongitude);
     Fpop_scope.ScopeShow;
     Fpop_scope.Enabled:=true;
     TelescopeTimer.Interval:=2000;
     TelescopeTimer.Enabled:=true;
end;
if assigned(FUpdateBtn) then FUpdateBtn(sc.cfgsc.flipx,sc.cfgsc.flipy,Connect1.checked,self);
end;

procedure Tf_chart.SlewASCOM(Sender: TObject);
var ra,dec:double;
    ok:boolean;
begin
ra:=sc.cfgsc.FindRA;
dec:=sc.cfgsc.FindDec;
if sc.cfgsc.TelescopeJD=0 then begin
  precession(sc.cfgsc.JDChart,sc.cfgsc.CurJD,ra,dec);
end else begin
  if sc.cfgsc.ApparentPos then mean_equatorial(ra,dec,sc.cfgsc,true,sc.cfgsc.FindType<ftPla);
  precession(sc.cfgsc.JDChart,sc.cfgsc.TelescopeJD,ra,dec);
end;
ra:=rmod(ra+pi2,pi2);
Fpop_scope.ScopeGoto(ra*rad2deg/15,dec*rad2deg,ok);
end;

procedure Tf_chart.AbortSlewASCOM(Sender: TObject);
begin
Fpop_scope.ScopeAbortSlew;
end;

procedure Tf_chart.SyncASCOM(Sender: TObject);
var ra,dec:double;
begin
ra:=sc.cfgsc.FindRA;
dec:=sc.cfgsc.FindDec;
if sc.cfgsc.TelescopeJD=0 then begin
   precession(sc.cfgsc.JDChart,sc.cfgsc.CurJD,ra,dec);
end else begin
   if sc.cfgsc.ApparentPos then mean_equatorial(ra,dec,sc.cfgsc,true,sc.cfgsc.FindType<ftPla);
   precession(sc.cfgsc.JDChart,sc.cfgsc.TelescopeJD,ra,dec);
end;
ra:=rmod(ra+pi2,pi2);
Fpop_scope.ScopeAlign(sc.cfgsc.FindName,ra*rad2deg/15,dec*rad2deg);
end;

procedure Tf_chart.TelescopeTimerTimer(Sender: TObject);
var ra,dec:double;
    ok, newconnection: boolean;
begin
try
TelescopeTimer.Enabled:=false;
{$ifdef trace_debug}
 WriteTrace(caption+' TelescopeTimerTimer');
{$endif}
newconnection:=Connect1.checked;
if sc.cfgsc.ASCOMTelescope then begin
     Connect1.checked:=Fpop_scope.ScopeConnected;
     if Connect1.checked then begin
      Fpop_scope.ScopeGetEqSys(sc.cfgsc.TelescopeJD);
      if sc.cfgsc.TelescopeJD<>0 then sc.cfgsc.TelescopeJD:=jd(trunc(sc.cfgsc.TelescopeJD),0,0,0);
      Fpop_scope.ScopeGetRaDec(ra,dec,ok);
     end;
 end
else if sc.cfgsc.IndiTelescope then begin
     Connect1.checked:=Fpop_indi.ScopeConnected;
     if Connect1.checked then begin
      Fpop_indi.ScopeGetEqSys(sc.cfgsc.TelescopeJD);
      if sc.cfgsc.TelescopeJD<>0 then sc.cfgsc.TelescopeJD:=jd(trunc(sc.cfgsc.TelescopeJD),0,0,0);
      Fpop_indi.ScopeGetRaDec(ra,dec,ok);
     end;
 end
else if sc.cfgsc.LX200Telescope then begin
     Connect1.checked:=Fpop_lx200.ScopeConnected;
     if Connect1.checked then begin
      Fpop_lx200.ScopeGetEqSys(sc.cfgsc.TelescopeJD);
      if sc.cfgsc.TelescopeJD<>0 then sc.cfgsc.TelescopeJD:=jd(trunc(sc.cfgsc.TelescopeJD),0,0,0);
      Fpop_lx200.ScopeGetRaDec(ra,dec,ok);
     end;
 end
else if sc.cfgsc.EncoderTelescope then begin
     Connect1.checked:=Fpop_encoder.ScopeConnected;
     if Connect1.checked then begin
      Fpop_encoder.ScopeGetEqSys(sc.cfgsc.TelescopeJD);
      if sc.cfgsc.TelescopeJD<>0 then sc.cfgsc.TelescopeJD:=jd(trunc(sc.cfgsc.TelescopeJD),0,0,0);
      Fpop_encoder.ScopeGetRaDec(ra,dec,ok);
     end;
end;
newconnection:=(not newconnection) and Connect1.checked;
if newconnection and (not sc.cfgsc.TrackOn) then sc.cfgsc.TrackName:=rsTelescope;
if Connect1.checked then begin
 if ok then begin
    ra:=ra*15*deg2rad;
    dec:=dec*deg2rad;
    if sc.cfgsc.TelescopeJD=0 then precession(sc.cfgsc.CurJD,sc.cfgsc.JDChart,ra,dec)
       else precession(sc.cfgsc.TelescopeJD,sc.cfgsc.JDChart,ra,dec);
    if sc.TelescopeMove(ra,dec) then identlabel.Visible:=false;
    if sc.cfgsc.moved then begin
       Image1.Invalidate;
       if assigned(FChartMove) then FChartMove(self);
    end;
    if (sc.cfgsc.TrackName=rsTelescope)and (not sc.cfgsc.TrackOn) then begin
      sc.cfgsc.TrackType:=6;
      sc.cfgsc.TrackName:=rsTelescope;
      sc.cfgsc.TrackRA:=sc.cfgsc.ScopeRa;
      sc.cfgsc.TrackDec:=sc.cfgsc.ScopeDec;
    end;
 end;
 TelescopeTimer.Interval:=500;
 TelescopeTimer.Enabled:=true;
 end else begin
  TelescopeTimer.Interval:=2000;
  TelescopeTimer.Enabled:=true;
  if sc.cfgsc.ScopeMark then begin
     sc.cfgsc.ScopeMark:=false;
     if sc.cfgsc.TrackName=rsTelescope then sc.cfgsc.TrackOn:=false;
     Refresh;
  end;
end;
if assigned(FUpdateBtn) then FUpdateBtn(sc.cfgsc.flipx,sc.cfgsc.flipy,Connect1.checked,self);
except
 TelescopeTimer.Enabled:=false;
 Connect1.checked:=false;
end;
end;

end.

