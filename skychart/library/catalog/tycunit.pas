unit tycunit;
{
Copyright (C) 2000 Patrick Chevalley

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

interface

uses
  skylibcat, sysutils;

type
    TYCrec = record
                     ar,de : longint;
                     gscz: word;
                     gscn: word;
                     tycn: word;
                     bt,vt,b_v,pmar,pmde :smallint;
                     end;
Function IsTYCpath(path : shortstring) : Boolean; stdcall;
procedure SetTYCpath(path : shortstring); stdcall;
Procedure OpenTYC(ar1,ar2,de1,de2: double ; var ok : boolean); stdcall;
Procedure OpenTYCwin(var ok : boolean); stdcall;
Procedure ReadTYC(var lin : TYCrec; var SMnum : shortstring ; var ok : boolean); stdcall;
Procedure NextTYC( var ok : boolean); stdcall;
procedure CloseTYC ; stdcall;

var
  TYCpath: String='';

implementation

const CacheNum = 100;

var
   ftyc : file of TYCrec ;
   curSM : integer;
   SMname,NomFich : string;
   hemis : char;
   zone,Sm,nSM : integer;
   hemislst : array[1..732] of char;
   zonelst,SMlst : array[1..732] of integer;
   FileIsOpen : Boolean = false;
   cache : array[1..CacheNum] of array of TYCrec;
   cachelst,Imax,Iread : array[1..CacheNum] of integer;
   OnCache : boolean;
   Ncache,Icache : integer;
   lastcache : integer = 0;

Function IsTYCpath(path : shortstring) : Boolean;
var p : string;
begin
p:=slash(path);
result:=    FileExists(p+'n0000'+slashchar+'001.dat')
         or FileExists(p+'n0730'+slashchar+'049.dat')
         or FileExists(p+'n1500'+slashchar+'096.dat')
         or FileExists(p+'n2230'+slashchar+'141.dat')
         or FileExists(p+'n3000'+slashchar+'184.dat')
         or FileExists(p+'n3730'+slashchar+'224.dat')
         or FileExists(p+'n4500'+slashchar+'260.dat')
         or FileExists(p+'n5230'+slashchar+'292.dat')
         or FileExists(p+'n6000'+slashchar+'319.dat')
         or FileExists(p+'n6730'+slashchar+'340.dat')
         or FileExists(p+'n7500'+slashchar+'355.dat')
         or FileExists(p+'n8230'+slashchar+'364.dat')
         or FileExists(p+'s0000'+slashchar+'367.dat')
         or FileExists(p+'s0730'+slashchar+'415.dat')
         or FileExists(p+'s1500'+slashchar+'462.dat')
         or FileExists(p+'s2230'+slashchar+'507.dat')
         or FileExists(p+'s3000'+slashchar+'550.dat')
         or FileExists(p+'s3730'+slashchar+'590.dat')
         or FileExists(p+'s4500'+slashchar+'626.dat')
         or FileExists(p+'s5230'+slashchar+'658.dat')
         or FileExists(p+'s6000'+slashchar+'685.dat')
         or FileExists(p+'s6730'+slashchar+'706.dat')
         or FileExists(p+'s7500'+slashchar+'721.dat')
         or FileExists(p+'s8230'+slashchar+'730.dat')
end;

procedure SetTYCpath(path : shortstring);
var i : integer;
begin
path:=noslash(path);
if path<>TYCpath then for i:=1 to CacheNum do cachelst[i]:=0;
TYCpath:=path;
end;

Procedure CloseRegion;
begin
{$I-}
if fileisopen then begin
FileisOpen:=false;
closefile(ftyc);
end;
{$I+}
end;

Procedure Openfile(nomfich : string; var ok : boolean);
begin
ok:=false;
if not FileExists(nomfich)  then begin
   ok:=false;
   exit;
end;
AssignFile(ftyc,nomfich);
FileisOpen:=true;
FileMode:=0;
reset(ftyc);
ok:=true;
end;

Procedure OpenRegion(hemis : char ;zone,S : integer ; var ok:boolean);
var nomzone,nomreg :string;
    i,j : integer;
begin
OnCache:=false;
if UseCache then for i:=1 to CacheNum do if cachelst[i]=s then begin OnCache:=true; Ncache:=i; break; end;
str(S:3,nomreg);
SMname:=nomreg;
Icache:=-1;
if fileisopen then CloseRegion;
str(abs(zone):4,nomzone);
nomfich:=TYCpath+slashchar+hemis+padzeros(nomzone,4)+slashchar+padzeros(nomreg,3)+'.dat';
if not OnCache then begin
OpenFile(nomfich,ok);
if not ok then exit;
if UseCache then begin
   j:=lastcache+1;
   if j>CacheNum then j:=1;
   cachelst[j]:=s;
   Ncache:=j;
   lastcache:=j;
   SetLength(cache[Ncache],1);
   Imax[Ncache]:=filesize(ftyc)-1;
   Iread[Ncache]:=0;
   SetLength(cache[Ncache],Imax[Ncache]+1);
end;
end;
ok:=true;
end;

Procedure OpenTYC(ar1,ar2,de1,de2: double ; var ok : boolean);
begin
JDCatalog:=jd2000;
curSM:=1;
ar1:=ar1*15; ar2:=ar2*15;
if Usecache then FindRegionList7(ar1,ar2,de1,de2,nSM,zonelst,SMlst,hemislst)
            else FindRegionAll7(ar1,ar2,de1,de2,nSM,zonelst,SMlst,hemislst);
hemis:= hemislst[curSM];
zone := zonelst[curSM];
Sm := Smlst[curSM];
OpenRegion(hemis,zone,Sm,ok);
end;

Procedure ReadTYC(var lin : TYCrec; var SMnum : shortstring ; var ok : boolean);
begin
ok:=true;
inc(Icache);
while ok and((OnCache and(Icache>Imax[Ncache]))or((not OnCache) and eof(ftyc))) do begin
  dec(Icache);
  NextTYC(ok);
  inc(Icache);
end;
if OnCache then begin
  if ok then begin
     if Icache<=Iread[ncache] then lin:=cache[Ncache,Icache]
     else begin
       if not fileisopen then begin
          OpenFile(nomfich,ok);
          if not ok then exit;
          seek(ftyc,Icache);
       end;
       Read(ftyc,lin);
       cache[Ncache,Icache]:=lin;
       Iread[ncache]:=Icache;
     end;
  end;
end else begin
  if ok then begin
     Read(ftyc,lin);
     if UseCache then begin
        cache[Ncache,Icache]:=lin;
        Iread[ncache]:=Icache;
     end;
  end;
end;
SMnum:=SMname;
end;

Procedure NextTYC( var ok : boolean);
begin
if OnCache then begin
end else begin
  CloseRegion;
end;
  inc(curSM);
  if curSM>nSM then ok:=false
  else begin
    hemis:= hemislst[curSM];
    zone := zonelst[curSM];
    Sm := Smlst[curSM];
    OpenRegion(hemis,zone,Sm,ok);
  end;
end;

procedure CloseTYC ;
begin
curSM:=nSM;
CloseRegion;
end;

Procedure OpenTYCwin(var ok : boolean);
begin
JDCatalog:=jd2000;
curSM:=1;
if usecache then FindRegionListWin7(nSM,zonelst,SMlst,hemislst)
            else FindRegionAllWin7(nSM,zonelst,SMlst,hemislst);
hemis:= hemislst[curSM];
zone := zonelst[curSM];
Sm := Smlst[curSM];
OpenRegion(hemis,zone,Sm,ok);
end;

end.
 