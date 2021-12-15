procedure TForm1.CombineTiles;
var
tempPNG: TPortableNetworkGraphic;
destPNG: TPortableNetworkGraphic;
x, y: Integer;
rect1, rect2: TRect;
PixPtr : PByte;
begin

tempPNG := TPortableNetworkGraphic.Create;
tempPNG.Width:= 256;
tempPNG.Height:= 256;

destPNG := TPortableNetworkGraphic.Create;
destPNG.height:= 768;
destPNG.width:= 768;
rect1.Create(0,0,256,256);

tempPNG.LoadFromFile('terrain/Tiles/8/' + intToStr(TilesArray[0]) + '/' + intToStr(TilesArray[1]) + '.png');
rect2.Create(256,256,512,512);
destPNG.Canvas.CopyRect(rect2, tempPNG.Canvas, rect1);

tempPNG.LoadFromFile('terrain/Tiles/8/' + intToStr(TilesArray[0]) + '/' + intToStr(TilesArray[1] - 1) + '.png');
rect2.Create(256,0,512,256);
destPNG.Canvas.CopyRect(rect2, tempPNG.Canvas, rect1);

tempPNG.LoadFromFile('terrain/Tiles/8/' + intToStr(TilesArray[0] - 1) + '/' + intToStr(TilesArray[1] - 1) + '.png');
rect2.Create(0,0,256,256);
destPNG.Canvas.CopyRect(rect2, tempPNG.Canvas, rect1);

tempPNG.LoadFromFile('terrain/Tiles/8/' + intToStr(TilesArray[0] - 1) + '/' + intToStr(TilesArray[1]) + '.png');
rect2.Create(0,256,256,512);
destPNG.Canvas.CopyRect(rect2, tempPNG.Canvas, rect1);

tempPNG.LoadFromFile('terrain/Tiles/8/' + intToStr(TilesArray[0] - 1) + '/' + intToStr(TilesArray[1] + 1) + '.png');
rect2.Create(0,512,256,768);
destPNG.Canvas.CopyRect(rect2, tempPNG.Canvas, rect1);

tempPNG.LoadFromFile('terrain/Tiles/8/' + intToStr(TilesArray[0]) + '/' + intToStr(TilesArray[1] + 1) + '.png');
rect2.Create(256,512,512,768);
destPNG.Canvas.CopyRect(rect2, tempPNG.Canvas, rect1);

tempPNG.LoadFromFile('terrain/Tiles/8/' + intToStr(TilesArray[0] + 1) + '/' + intToStr(TilesArray[1] + 1) + '.png');
rect2.Create(512,512,768,768);
destPNG.Canvas.CopyRect(rect2, tempPNG.Canvas, rect1);

tempPNG.LoadFromFile('terrain/Tiles/8/' + intToStr(TilesArray[0] + 1) + '/' + intToStr(TilesArray[1]) + '.png');
rect2.Create(512,256,768,512);
destPNG.Canvas.CopyRect(rect2, tempPNG.Canvas, rect1);

tempPNG.LoadFromFile('terrain/Tiles/8/' + intToStr(TilesArray[0] + 1) + '/' + intToStr(TilesArray[1] - 1) + '.png');
rect2.Create(512,0,768,256);
destPNG.Canvas.CopyRect(rect2, tempPNG.Canvas, rect1);

//Mirror the image
rect1.Create(0,0,768,768);
rect2.Create(0,768,768,0);
destPNG.Canvas.CopyRect(rect1,destPNG.Canvas, rect2);

for Y := 0 to cTRTileSize - 1 do
begin
  PixPtr := destPNG.RawImage.GetLineStart(y);
  //for X := se1.value to se1.value + 1024 - 1 do
  for X := 0 to cTRTileSize - 1 do
  begin
    TRTileCArray[X, Y] := PixPtr^;
    inc(PixPtr, 3);
  end;
end;

destPNG.SaveToFile('test.png');
//TRTileMatLib.LibMaterialByName('HMC').Material.Texture.Assign(destPNG);
tempPNG.free;
destPNG.Free;


end;  
