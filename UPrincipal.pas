unit UPrincipal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, DB, ADODB, DBClient, TeEngine, Series, BubbleCh,
  ExtCtrls, TeeProcs, Chart, DbChart, Grids, DBGrids, DBXpress, SqlExpr,
  ComCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    DBChart1: TDBChart;
    ADOConnection1: TADOConnection;
    ADOQuery1: TADOQuery;
    ADOQuery1x: TFloatField;
    ADOQuery1px2: TFloatField;
    BitBtn1: TBitBtn;
    Series1: TPointSeries;
    Bevel1: TBevel;
    cmbbxN: TComboBox;
    ProgressBar1: TProgressBar;
    StaticText1: TStaticText;
    procedure cmbbxNClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    procedure entra(Sender : TObject);
    procedure sai(Sender : TObject);
  end;

var
  Form1: TForm1;
  Arq1,Arq : TextFile;
  arqx,arqy : TextFile;
  x,y: array[0..100] of real;
  edtsX: array of TEdit;
    edtsY: array of TEdit;
    lblsX: array of TLabel;
    lblsY: array of TLabel;
    qtd : integer;
implementation

{$R *.dfm}



procedure Lagrange(Grau : integer);
var   i,j,k : integer;
      h,Xzao,px,soma,num,den,L : real;
begin
      Rewrite(arq1,'saida.xls');
      Rewrite(arqx,'x.txt');
      Rewrite(arqy,'y.txt');
      Writeln(arq1,'x'+#9+'p(x)');
      h:= (x[grau]-x[0])/100;
      Xzao:=x[0];
      for k := 1 to 101 do
      begin
        soma:=0;
        for i := 0 to grau do
          begin
            num:=1;
            den:=1;
            for j := 0 to grau do
            begin
              if (i<>j) then
              begin
                num := num *(Xzao-x[j]);
                den := den * (x[i]-x[j]);
              end;
            end;
            L:=num/den;
            soma :=soma + (L*y[i]);
          end;
          px:=soma;
          Writeln(arq1,(floatToStr(xzao))+#9+floatToStr(px));
          Writeln(arqx,(floatToStr(xzao)));
          Writeln(arqy,floatToStr(px));
          xzao:=x[0]+k*h;
      end;
      CloseFile(arq1);
      CloseFile(arqx);
      CloseFile(arqy);
end;

procedure Ler_dados;
var n,i,grau : integer;
begin
Form1.ProgressBar1.StepBy(1);

  grau:= qtd-1;
  for I := 0 to grau do
  begin
    x[i]:=StrToFloat(edtsX[i].text);
    y[i]:=StrToFloat(edtsy[i].text);
  end;
      Lagrange(grau);
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
var xs,ys : TStringList;
    i : integer;
begin
Form1.ProgressBar1.Position:=0;
Ler_dados;

xs:=TStringList.create;
ys:=TStringList.create;
xs.LoadFromFile('x.txt');
ys.LoadFromFile('y.txt');
ADOQuery1.first;

while not ADOQuery1.eof do
begin
Form1.ProgressBar1.StepBy(1);
ADOQuery1.active:=false;
ADOQuery1.active:=true;
ADOQuery1.open;
Form1.ProgressBar1.StepBy(1);
Form1.StaticText1.Caption:='Gerando Gráfico... '+FormatFloat('0#',Form1.ProgressBar1.Position/3)+'%';
ADOQuery1.Delete;
ADOQuery1.first;
end;


for I := 0 to xs.Count - 1 do
begin
ADOQuery1.Edit;
Form1.ProgressBar1.StepBy(1);
Form1.StaticText1.Caption:='Gerando Gráfico... '+FormatFloat('0#',Form1.ProgressBar1.Position/3)+'%';
ADOQuery1x.Value:=strtoFloat(xs.Strings[i]);
ADOQuery1px2.Value:=strtoFloat(ys.Strings[i]);
ADOQuery1.Append;
ADOQuery1.Open;
end;
Form1.StaticText1.Caption:='Completo... '+FormatFloat('0#',Form1.ProgressBar1.Position/3)+'%';
end;

procedure TForm1.cmbbxNClick(Sender: TObject);
var
    I: Integer;
begin
  if qtd >0 then
  begin
    for I := 0 to qtd -1 do
    begin
     FreeAndNil(edtsX[i]);
     FreeAndNil(edtsY[i]);
     FreeAndNil(lblsX[i]);
     FreeAndNil(lblsY[i]);
    end;
  qtd:=0;
  end;
  Bevel1.Visible:=false;

  qtd:= strToInt(cmbbxN.text);
  //qtd:=qtd-1;
  SetLength(edtsX,qtd);
  SetLength(lblsX,qtd);
  SetLength(edtsY,qtd);
  SetLength(lblsY,qtd);

  for I := 0 to qtd-1 do
  begin

    if i > 3  then
    begin
      Bevel1.Visible:=true;
      //X
      lblsX[i]:= TLabel.Create(self);
      lblsX[i].Left:=430;
      lblsX[i].Top:= 64+((i-4)*32);
      lblsX[i].Font.Name:='Times New Roman';
      lblsX[i].Font.Size:=12;
      lblsX[i].Caption:='X'+intTostr(i+1);
      lblsX[i].Parent:=self;
      edtsX[i]:= TEdit.Create(self);
      edtsX[i].Left:=452;
      edtsX[i].Top:= 60+((i-4)*32);
      edtsX[i].Font.Name:='Times New Roman';
      edtsX[i].Font.Size:=12;
      edtsX[i].Parent:=self;
      edtsX[i].OnEnter:=entra;
      edtsX[i].OnExit:=sai;

      //Y
      lblsY[i]:= TLabel.Create(self);
      lblsY[i].Left:=580;
      lblsY[i].Top:= 64+((i-4)*32);
      lblsY[i].Font.Name:='Times New Roman';
      lblsY[i].Font.Size:=12;
      lblsY[i].Caption:='Y'+intTostr(i+1);
      lblsY[i].Parent:=self;
      edtsY[i]:= TEdit.Create(self);
      edtsY[i].Left:=602;
      edtsY[i].Top:= 60+((i-4)*32);
      edtsY[i].Font.Name:='Times New Roman';
      edtsY[i].Font.Size:=12;
      edtsY[i].Parent:=self;
      edtsY[i].OnEnter:=entra;
      edtsY[i].OnExit:=sai;
    end
    else begin
    //X
    lblsX[i]:= TLabel.Create(self);
    lblsX[i].Left:=80;
    lblsX[i].Top:= 64+(i*32);
    lblsX[i].Font.Name:='Times New Roman';
    lblsX[i].Font.Size:=12;
    lblsX[i].Caption:='X'+intTostr(i+1);
    lblsX[i].Parent:=self;
    edtsX[i]:= TEdit.Create(self);
    edtsX[i].Left:=102;
    edtsX[i].Top:= 60+(i*32);
    edtsX[i].Font.Name:='Times New Roman';
    edtsX[i].Font.Size:=12;
    edtsX[i].Parent:=self;
    edtsX[i].OnEnter:=entra;
    edtsX[i].OnExit:=sai;

    //Y
    lblsY[i]:= TLabel.Create(self);
    lblsY[i].Left:=230;
    lblsY[i].Top:= 64+(i*32);
    lblsY[i].Font.Name:='Times New Roman';
    lblsY[i].Font.Size:=12;
    lblsY[i].Caption:='Y'+intTostr(i+1);
    lblsY[i].Parent:=self;
    edtsY[i]:= TEdit.Create(self);
    edtsY[i].Left:=252;
    edtsY[i].Top:= 60+(i*32);
    edtsY[i].Font.Name:='Times New Roman';
    edtsY[i].Font.Size:=12;
    edtsY[i].Parent:=self;
    edtsY[i].OnEnter:=entra;
    edtsY[i].OnExit:=sai;
    end;

  end;
  edtsX[0].SetFocus;

end;

procedure TForm1.entra(Sender: TObject);
begin
  if Sender is TEdit then
  begin
    (Sender as TEdit).Color:=clNavy;
    (Sender as TEdit).Font.Color:=clWhite;
  end;
end;

procedure TForm1.sai(Sender: TObject);
begin
  if Sender is TEdit then
  begin
    (Sender as TEdit).Color:=clwhite;
    (Sender as TEdit).Font.Color:=clBlack;
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var
  I: Integer;
begin
    for I := 0 to Length(edtsX)-1 do
    begin
      FreeAndNil(edtsX[i]);
      FreeAndNil(edtsY[i]);
      FreeAndNil(lblsX[i]);
      FreeAndNil(lblsY[i]);
    end;
end;

end.
