unit UnitTesting;

interface

uses

  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.Math, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.ExtCtrls, PNGImage;

type
  TFrmTesting = class(TForm)
    ImageAvatar: TImage;
    BtnChangePic: TButton;
    dlgOpen1: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure BtnChangePicClick(Sender: TObject);
  private
    procedure LoadPicture(PMask, PPic: string);

  public
    { Public declarations }
  end;

var
  FrmTesting: TFrmTesting;

implementation

{$R *.dfm}

procedure TFrmTesting.LoadPicture(PMask, PPic: string);
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

  function CreateAvatar(Source: TGraphic; Mask: TPngImage): TPngImage;
  begin
    Result := TPngImage.CreateBlank(COLOR_RGB, 16, Mask.Width, Mask.Height);
    Result.Canvas.StretchDraw(Rect(0, 0, Mask.Width, Mask.Height), Source);
    Result.CreateAlpha;
    ApplyMask(0, 0, Mask, Result);
  end;

var
  Pic: TPicture;
  PNG, FStatusMask: TPngImage;
begin
  FStatusMask:= TPngImage.Create;
  FStatusMask.LoadFromFile(PMask);
  Pic:= TPicture.Create;
  Pic.LoadFromFile(PPic);
  PNG:= CreateAvatar(Pic.Graphic, FStatusMask);
  ImageAvatar.Picture.Assign(PNG);
  PNG.Free;
  Pic.Free;
end;

procedure TFrmTesting.BtnChangePicClick(Sender: TObject);
begin
  if dlgOpen1.Execute() then
    LoadPicture('mask.png', dlgOpen1.FileName);
end;

procedure TFrmTesting.FormCreate(Sender: TObject);
begin
  LoadPicture('mask.png', 'PNGSample.png');
end;

end.
