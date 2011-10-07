unit pr_vodetail;

{$MODE Delphi}

{                                        
Copyright (C) 2011 Patrick Chevalley

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
 Detail of catalog for the Virtual Observatory interface.
}

interface

uses u_translation, u_voconstant,
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, ExtCtrls, cu_radec, enhedits, LResources, Buttons;

type

  { Tf_vodetail }

  Tf_vodetail = class(TForm)
    Button2: TButton;
    ButtonBack: TButton;
    CheckBox1: TCheckBox;
    ColorDialog1: TColorDialog;
    ComboBox1: TComboBox;
    FullDownload: TCheckBox;
    Grid: TStringGrid;
    Label1: TLabel;
    Label10: TLabel;
    Label9: TLabel;
    DefMag: TLongEdit;
    DefSize: TLongEdit;
    Shape1: TShape;
    tr: TLongEdit;
    Panel1: TPanel;
    MainPanel: TPanel;
    RadioGroup1: TRadioGroup;
    Table: TLabel;
    Rows: TLabel;
    tn: TEdit;
    desc: TMemo;
    Button1: TButton;
    RaDec1: TRaDec;
    RaDec2: TRaDec;
    Label4: TLabel;
    Label5: TLabel;
    RaDec3: TRaDec;
    Label6: TLabel;
    procedure Button2Click(Sender: TObject);
    procedure ButtonBackClick(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FullDownloadChange(Sender: TObject);
    procedure GetData(Sender: TObject);
    procedure GridMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RadioGroup1Click(Sender: TObject);
    procedure Shape1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    FPreviewData, FGetData, FGoback: TNotifyEvent ;
  public
    { Public declarations }
    SelectAll: boolean;
    vo_maxrecord: integer;
    drawcolor: Tcolor;
    forcecolor: integer;
    drawtype: integer;
    procedure Setlang;
    property onPreviewData: TNotifyEvent read FPreviewData write FPreviewData;
    property onGetData: TNotifyEvent read FGetData write FGetData;
    property onGoback: TNotifyEvent read FGoback write FGoback;
  end;

implementation
{$R *.lfm}

procedure Tf_vodetail.Setlang;
begin
table.Caption:=rsTable;
Rows.Caption:=rsRows;
Label10.Caption:=rsDefaultMagni;
Label9.Caption:=rsDefaultSizeA;
Label1.Caption:=rsObjectType;
Label4.Caption:=rsRA;
Label5.Caption:=rsDEC;
Label6.Caption:=rsFOV;
FullDownload.Caption:=rsDownloadFull;
ButtonBack.Caption:='< '+rsBack;
Button1.Caption:=rsDownloadCata;
Button2.Caption:=rsDataPreview;
RadioGroup1.Items[0]:=rsCannotDraw;
RadioGroup1.Items[1]:=rsDrawAsStar;
RadioGroup1.Items[2]:=rsDrawAsDSO;
ComboBox1.Items[0]:=rsUnknowObject;
ComboBox1.Items[1]:=rsGalaxy;
ComboBox1.Items[2]:=rsOpenCluster;
ComboBox1.Items[3]:=rsGlobularClus;
ComboBox1.Items[4]:=rsPlanetaryNeb;
ComboBox1.Items[5]:=rsBrightNebula;
ComboBox1.Items[6]:=rsClusterAndNe;
ComboBox1.Items[7]:=rsStar;
ComboBox1.Items[8]:=rsDoubleStar;
ComboBox1.Items[9]:=rsTripleStar;
ComboBox1.Items[10]:=rsAsterism;
ComboBox1.Items[11]:=rsKnot;
ComboBox1.Items[12]:=rsGalaxyCluste;
ComboBox1.Items[13]:=rsDarkNebula;
ComboBox1.Items[14]:=rsCircle;
ComboBox1.Items[15]:=rsSquare;
ComboBox1.Items[16]:=rsLosange;

end;

procedure Tf_vodetail.GetData(Sender: TObject);
begin
if assigned(FGetData) then FGetData(self);
end;

procedure Tf_vodetail.FullDownloadChange(Sender: TObject);
begin
if FullDownload.Checked and (tr.Value>vo_fullmaxrecord) then begin
   ShowMessage(Format(rsThisCatalogC, [inttostr(tr.value)]));
   FullDownload.Checked:=false;
end;
if FullDownload.Checked and (tr.Value=0) then begin
   ShowMessage(Format(rsTheNumberOfR, [inttostr(vo_fullmaxrecord)]));
end;
if FullDownload.Checked then begin
   RaDec1.Enabled:=false;
   RaDec2.Enabled:=false;
   RaDec3.Enabled:=false;
end else begin
   RaDec1.Enabled:=true;
   RaDec2.Enabled:=true;
   RaDec3.Enabled:=true;
end;

end;

procedure Tf_vodetail.ButtonBackClick(Sender: TObject);
begin
  if assigned(FGoback) then FGoback(self);
end;

procedure Tf_vodetail.CheckBox1Change(Sender: TObject);
begin
if  CheckBox1.Checked then forcecolor:=1
    else forcecolor:=0;
end;

procedure Tf_vodetail.ComboBox1Change(Sender: TObject);
begin
  drawtype:=ComboBox1.ItemIndex;
end;

procedure Tf_vodetail.Button2Click(Sender: TObject);
begin
  if assigned(FPreviewData) then FPreviewData(self);
end;

procedure Tf_vodetail.FormCreate(Sender: TObject);
begin
  Setlang;
  drawtype:=14;
  ComboBox1.ItemIndex:=drawtype;
  drawcolor:=clGray;
  ColorDialog1.Color:=drawcolor;
  shape1.Brush.Color:=drawcolor;
  forcecolor:=0;
  CheckBox1.Checked:=(forcecolor=1);
end;

procedure Tf_vodetail.GridMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var Column,Row,i : integer;
    mark : string;
begin
grid.MouseToCell(X, Y, Column, Row);
if (row>0)and(Column=0) then begin
   if grid.Cells[Column,Row]='' then mark:='x'
      else mark:='';
   grid.Cells[Column,Row]:=mark;
end;
if (row=0)and(Column=0) then begin
   SelectAll:=not SelectAll;
   if SelectAll then mark:='x'
      else mark:='';
   for i:=1 to grid.RowCount-1 do
      grid.Cells[0,i]:=mark;
end;
end;

procedure Tf_vodetail.Shape1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if ColorDialog1.Execute then begin
   drawcolor:=ColorDialog1.Color;
   Shape1.Brush.Color:=drawcolor;
end;
end;

procedure Tf_vodetail.RadioGroup1Click(Sender: TObject);
begin
case RadioGroup1.ItemIndex of
0: begin
   Button1.Enabled:=false;
   FullDownload.Enabled:=false;
   ComboBox1.Enabled:=false;
   DefSize.Enabled:=false;
   CheckBox1.Enabled:=false;
   Shape1.Enabled:=false;
   label1.Enabled:=false;
   label9.Enabled:=false;
   end;
1: begin
   Button1.Enabled:=true;
   FullDownload.Enabled:=true;
   ComboBox1.Enabled:=false;
   DefSize.Enabled:=false;
   CheckBox1.Enabled:=false;
   Shape1.Enabled:=false;
   label1.Enabled:=false;
   label9.Enabled:=false;
   end;
2 : begin
   Button1.Enabled:=true;
   FullDownload.Enabled:=true;
   ComboBox1.Enabled:=true;
   DefSize.Enabled:=true;
   CheckBox1.Enabled:=true;
   Shape1.Enabled:=true;
   label1.Enabled:=true;
   label9.Enabled:=true;
   end
end;
end;



end.
