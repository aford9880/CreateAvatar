unit UnitTesting;

interface

uses

  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.Math, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.ExtCtrls, PNGImage, Vcl.Direct2D, Winapi.D2D1, CurvyControls;

type
  TFrmTesting = class(TForm)
    dlgOpen1: TOpenDialog;
    crvypnl1: TCurvyPanel;
    ImageAvatar: TImage;
    BtnChangePic: TButton;
    procedure FormCreate(Sender: TObject);
    procedure BtnChangePicClick(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormResize(Sender: TObject);
  private
    procedure LoadPicture(PMask, PBorder, PPic: string);

  public
    { Public declarations }
  end;

var
  FrmTesting: TFrmTesting;

implementation

{$R *.dfm}

procedure TFrmTesting.LoadPicture(PMask, PBorder, PPic: string);
var
  Pic: TPicture;
  PNG, FStatusMask, border: TPngImage;

  procedure ApplyMask(X, Y: Integer; Mask, Target: TPngImage);
  var
    dX, dY: Integer;
    DAS, SAS: pByteArray;
  begin
    for dY := 0 to Mask.Height - 1 do
    begin
      SAS := Mask.AlphaScanline[dY];
      DAS := Target.AlphaScanline[dY + Y];
      for dX := 0 to Mask.Width - 1 do
      begin
        DAS[dX + X] := Min(DAS[dX + X], SAS[dX]);
      end;
    end;
  end;

  function SmoothStrechDraw(Source: TGraphic; Size: TSize): TBitmap;
  var
    pt: TPoint;
    h: HDC;
    BMP: TBitmap;
  begin
    BMP := TBitmap.Create;
    BMP.PixelFormat := pf24bit;
    BMP.SetSize(Source.Width, Source.Height);
    BMP.Canvas.Draw(0, 0, Source);

    Result := TBitmap.Create;
    Result.PixelFormat := pf24bit;
    Result.SetSize(Size.Width, Size.Height);

    h := Result.Canvas.Handle;
    GetBrushOrgEx(h, pt);
    SetStretchBltMode(h, HALFTONE);
    SetBrushOrgEx(h, pt.x, pt.y, @pt);
    StretchBlt(h, 0, 0, Result.Width, Result.Height, BMP.Canvas.Handle, 0, 0, BMP.Width, BMP.Height, SRCCOPY);
    BMP.Free;
  end;

  function CreateAvatar(Source: TGraphic; Mask: TPngImage): TPngImage;
    type
      TEllipseParams = record
        ALeft, ATop, ARight, ABottom: Integer
      end;

    type
      TDrawParams = record
        ACanvas: TCanvas;
        AEllipse: TEllipseParams;
        APenWidth: Integer;
        AColor: TColor;
      end;

    procedure DrawCircle(DrawParams: TDrawParams);
    begin
      with DrawParams, DrawParams.AEllipse do
        with TDirect2DCanvas.Create(ACanvas, Rect(0, 0, Mask.Width, Mask.Height)) do
        begin
          RenderTarget.BeginDraw;
          Brush.Style:= bsClear;
          Pen.Width:= APenWidth;
          Pen.Color:= AColor;
          RenderTarget.SetAntialiasMode(D2D1_ANTIALIAS_MODE_PER_PRIMITIVE);
          Ellipse(Rect(ALeft, ATop, ARight, ABottom));
          RenderTarget.EndDraw;
          Free;
        end;
    end;

  var
    BMPSmooth: TBitmap;
    Av: TPngImage;
    DrawParams: TDrawParams;
  begin
    BMPSmooth := SmoothStrechDraw(Source, TSize.Create(Mask.Width, Mask.Height));
    Result := TPngImage.CreateBlank(COLOR_RGB, 16, Mask.Width, Mask.Height);
    Result.Canvas.Draw(0, 0, BMPSmooth);

    with DrawParams do
    begin
      // наружная
      ACanvas:= Result.Canvas;
      AEllipse.ALeft:= 1;
      AEllipse.ATop:= 1;
      AEllipse.ARight:= Mask.Width - 1;
      AEllipse.ABottom:= Mask.Height - 1;
      APenWidth:= 40; //10;
      AColor:= clWhite; //$00FCC654;
      DrawCircle(DrawParams);

//      // середина
//      AEllipse.ALeft:= 10;
//      AEllipse.ATop:= 10;
//      AEllipse.ARight:= Mask.Width - 11;
//      AEllipse.ABottom:= Mask.Height - 11;
//      APenWidth:= 10;
//      AColor:= $00FDDB93;
//      DrawCircle(DrawParams);
//
//      // внутренняя
//      AEllipse.ALeft:= 20;
//      AEllipse.ATop:= 20;
//      AEllipse.ARight:= Mask.Width - 21;
//      AEllipse.ABottom:= Mask.Height - 21;
//      AColor:= $00FEE9BC;
//      DrawCircle(DrawParams);
    end;

    BMPSmooth.Free;
    Result.CreateAlpha;
    ApplyMask(0, 0, Mask, Result);
  end;

begin
  FStatusMask:= TPngImage.Create;
  border:= TPngImage.Create;
  Pic:= TPicture.Create;
  PNG:= nil;
  try
    FStatusMask.LoadFromFile(PMask);
    border.LoadFromFile(PBorder);
    Pic.LoadFromFile(PPic);
    PNG:= CreateAvatar(Pic.Graphic, FStatusMask);
    ImageAvatar.Picture.Assign(PNG);
  finally
    PNG.Free;
    Pic.Free;
    border.Free;
    FStatusMask.Free;
  end;
end;

procedure TFrmTesting.BtnChangePicClick(Sender: TObject);
begin
  if dlgOpen1.Execute() then
    LoadPicture('mask.png', 'border.png', dlgOpen1.FileName);
end;

procedure TFrmTesting.FormCreate(Sender: TObject);
var Bmp: TBitmap;
    MF: TMetaFile;
    MetafileCanvas: TMetafileCanvas;
begin
  LoadPicture('mask.png', 'border.png', 'PNGSample.png');
end;

procedure TFrmTesting.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  //Canvas.LineTo(x,y);
end;

procedure TFrmTesting.FormResize(Sender: TObject);
begin
  Invalidate;
end;

end.
