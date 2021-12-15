//AI VERSION 1 BEHAVIOUR
If v1AICounter > 0 then
begin

    For AInr := 1 to v1AICounter do
    begin

        if v1AIShips[AInr].enabled = true then
        begin

        Selv1AI := GLScene1.FindSceneObject(v1AIShips[AInr].name);
        Selv1AIColBox := GLScene1.FindSceneObject(v1AIShips[AInr].name + 'ColBox');

        Selv1AISpeedReduction := 0 + ((v1AIShips[AInr].topSpeed * 0.75) - ((v1AIShips[AInr].topSpeed * 0.75) * (v1AIShips[AInr].health / 100)));

                if (Selv1AIColBox.Count > 0) then
                begin
                   if (Selv1AI.Position.Y > -20) then
                   begin
                     for tempIntX := Selv1AIColBox.Count - 1 downTo 0 do
                     begin
                     GrabExplSpriteFX := fireFXholder.FindChild(Selv1AIColBox.Name + '_fireSprite' + intToStr(tempIntX + 1), true) as tglSprite;
                     GrabExplSpriteFX.AbsolutePosition := Selv1AIColBox.FindChild(Selv1AIColBox.Name + '_fireHolder' + intToStr(tempIntX + 1), true).AbsolutePosition;

                          if GrabExplSpriteFX.Material.LibMaterialName = '20' then
                          begin
                          GrabExplSpriteFX.Material.LibMaterialName := '1';
                          end
                          else
                          begin
                          tempIntY := strToInt(GrabExplSpriteFX.Material.LibMaterialName);
                          GrabExplSpriteFX.Material.LibMaterialName := intToStr(tempIntY + 1);
                          end;

                     end;
                   end
                   else
                   begin
                        for tempIntX := Selv1AIColBox.Count - 1 downTo 0 do
                        begin
                        GrabExplSpriteFX := fireFXholder.FindChild(Selv1AIColBox.Name + '_fireSprite' + intToStr(tempIntX + 1), true) as tglSprite;
                        GrabExplSpriteFX.Free;
                        end;
                        for tempIntX := Selv1AI.Count - 1 downTo 0 do
                        Selv1AI.Children[tempIntX].Effects.clear;

                   end;
                end;


                if (v1AIShips[AInr].stacks > 0) and (v1AIShips[AInr].enabled = true) then
                begin
                //Reset height after horizon tests
                v1AIShips[AInr].storedY := selv1AI.Position.Y;

                        //AI SINK ANIMATION
                        if v1AIShips[AInr].health < 1 then
                        begin
                                if Selv1AI.rollAngle > -90 then
                                Selv1AI.rollAngle := Selv1AI.rollAngle - 0.1;

                                if Selv1AI.pitchAngle > -15 then
                                Selv1AI.pitchAngle := Selv1AI.pitchAngle - 0.025;

                        Selv1AI.position.Y := Selv1AI.Position.Y - 0.05;

                        end
                        else
                        begin

                        //AI SHIP BOB ANIMATION
                        v1AIShips[AInr].roll := 0.75 * sin(0.6 * newTime);
                        Selv1AI.RollAngle := v1AIShips[AInr].roll;

                        Selv1AI.PitchAngle := 0.5 * sin(0.5 * newTime);
                        selv1AI.Position.Y := (v1AIShips[AInr].draftY) + 1 * sin(0.4 * newTime - 0.5); //+ 1 can be storm strength!?

                        end;

                 //Earth curvature test
                 v1AIShips[AInr].storedY := selv1AI.Position.Y;

                 tempSingX := selv1AI.DistanceTo(myShip);
                 if tempSingX > 80000 then
                 begin
                 tempSingX := tempSingX - 80000;
                 selv1AI.Position.Y := selv1AI.Position.Y - (30) * (tempSingX / 40000);
                 end;

                  if v1AIShips[AInr].mode = 0 then
                  begin
                  Selv1AIMapMarkerDirPointX := v1AIShips[AInr].waypoints[1, 0];
                  Selv1AIMapMarkerDirPointY := v1AIShips[AInr].waypoints[1, 1];

                  end;

                  if v1AIShips[AInr].mode = 3 then
                  begin
                    if v1AIShips[v1AIShips[AInr].convojInfo[0]].health > 10 then
                    begin

                    tempSingX2 := v1AIShips[v1AIShips[AInr].convojInfo[0]].NewPositionX - (-1 * v1AIShips[aiNr].convojInfo[3]) * sin((v1AIShips[v1AIShips[AInr].convojInfo[0]].Heading + 180 - v1AIShips[AInr].convojInfo[2]) * pi / 180);
                    tempSingY2 := v1AIShips[v1AIShips[AInr].convojInfo[0]].NewPositionY + (-1 * v1AIShips[aiNr].convojInfo[3]) * cos((v1AIShips[v1AIShips[AInr].convojInfo[0]].Heading + 180 - v1AIShips[AInr].convojInfo[2]) * pi / 180);

                    tempSingX := v1AIShips[AInr].NewPositionX;
                    tempSingY := v1AIShips[AInr].NewPositionY;

                    tempSingZ := sqrt(((tempSingX2 - tempSingX) * (tempSingX2 - tempSingX)) + ((tempSingY2 - tempSingY) * (tempSingY2 - tempSingY)));

                        if tempSingZ > 2 then
                        begin
                        v1AIShips[AInr].wantedSpeed := v1AIShips[v1AIShips[AInr].convojInfo[0]].wantedSpeed + 1;
                        end
                        else
                        begin
                        v1AIShips[AInr].wantedSpeed := v1AIShips[v1AIShips[AInr].convojInfo[0]].wantedSpeed;
                        end;
                    end
                    else
                    begin
                    v1AIShips[AInr].mode := 1;
                    end;
                  end;

                  if v1AIShips[AInr].mode = 2 then
                  begin
                  tempSingX2 := MyShipFictionalPosX / 100; //Sphere
                  tempSingY2 := MyShipFictionalPosZ / 100;

                  tempSingX := v1AIShips[AInr].NewPositionX; //Mapmarker
                  tempSingY := v1AIShips[AInr].NewPositionY;

                  tempSingZ := sqrt(((tempSingX2 - tempSingX) * (tempSingX2 - tempSingX)) + ((tempSingY2 - tempSingY) * (tempSingY2 - tempSingY)));

                      if tempSingZ < 1000 then
                      begin
                      AIBangleToPlayer := round(radtodeg(arctan2(tempSingY2 - tempSingY, tempSingX2 - tempSingX)));
                      AIBangleToPlayer := AIBangleToPlayer - 90;

                          if AIBangleToPlayer < -180 then
                          AIBangleToPlayer := AIBangleToPlayer + 360;

                          if AIBangleToPlayer < 0 then
                          begin
                          AIBangleToPlayer := AIBangleToPlayer - 10;
                          end
                          else
                          begin
                          AIBangleToPlayer := AIBangleToPlayer + 10;
                          end;

                      Selv1AIMapMarkerDirPointX := tempSingX2 + (200) * sin(AIBangleToPlayer * pi / 180);
                      Selv1AIMapMarkerDirPointY := tempSingY2 - (200) * cos(AIBangleToPlayer * pi / 180);
                      end
                      else
                      begin
                      Selv1AIMapMarkerDirPointX := v1AIShips[AInr].waypoints[1, 0];
                      Selv1AIMapMarkerDirPointY := v1AIShips[AInr].waypoints[1, 1];
                      end;
                  end;

                  if v1AIShips[AInr].mode = 1 then
                  begin
                  tempSingX2 := v1AIShips[v1AIShips[AInr].convojInfo[0]].NewPositionX - (-1 * v1AIShips[aiNr].convojInfo[3]) * sin((v1AIShips[v1AIShips[AInr].convojInfo[0]].Heading + 180 - v1AIShips[AInr].convojInfo[2]) * pi / 180);
                  tempSingY2 := v1AIShips[v1AIShips[AInr].convojInfo[0]].NewPositionY + (-1 * v1AIShips[aiNr].convojInfo[3]) * cos((v1AIShips[v1AIShips[AInr].convojInfo[0]].Heading + 180 - v1AIShips[AInr].convojInfo[2]) * pi / 180);

                  tempSingX := v1AIShips[AInr].NewPositionX;
                  tempSingY := v1AIShips[AInr].NewPositionY;

                  tempSingZ := sqrt(((tempSingX2 - tempSingX) * (tempSingX2 - tempSingX)) + ((tempSingY2 - tempSingY) * (tempSingY2 - tempSingY)));

                      if tempSingZ < 200 then
                      begin
                      AIBangleToPlayer := round(radtodeg(arctan2(tempSingY2 - tempSingY, tempSingX2 - tempSingX)));
                      AIBangleToPlayer := AIBangleToPlayer - 90;

                          if AIBangleToPlayer < -180 then
                          AIBangleToPlayer := AIBangleToPlayer + 360;

                          if AIBangleToPlayer < 0 then
                          begin
                          AIBangleToPlayer := AIBangleToPlayer - 10;
                          end
                          else
                          begin
                          AIBangleToPlayer := AIBangleToPlayer + 10;
                          end;

                      Selv1AIMapMarkerDirPointX := tempSingX2 + (210) * sin(AIBangleToPlayer * pi / 180);
                      Selv1AIMapMarkerDirPointY := tempSingY2 - (210) * cos(AIBangleToPlayer * pi / 180);
                      end
                      else
                      begin
                      Selv1AIMapMarkerDirPointX := tempSingX;
                      Selv1AIMapMarkerDirPointY := tempSingY;
                      end;
                  end;

                  tempSingX2 := v1AIShips[AInr].waypoints[1, 0];
                  tempSingY2 := v1AIShips[AInr].waypoints[1, 1];

                  tempSingX := v1AIShips[AInr].NewPositionX;
                  tempSingY := v1AIShips[AInr].NewPositionY;

                  tempSingZ := sqrt(((tempSingX2 - tempSingX) * (tempSingX2 - tempSingX)) + ((tempSingY2 - tempSingY) * (tempSingY2 - tempSingY)));

                          if tempSingZ < 2000 then
                          begin
                          tempIntX := v1AIShips[AInr].waypoints[0, 0];
                                  if tempIntX > 1 then
                                  begin
                                  v1AIShips[AInr].waypoints[0, 0] := v1AIShips[AInr].waypoints[0, 0] - 1;
                                  tempIntY := v1AIShips[AInr].waypoints[0, 0];
                                          for tempIntZ := 1 to tempIntY do
                                          begin
                                          v1AIShips[AInr].waypoints[tempIntZ, 0] := v1AIShips[AInr].waypoints[tempIntZ + 1, 0];
                                          v1AIShips[AInr].waypoints[tempIntZ, 1] := v1AIShips[AInr].waypoints[tempIntZ + 1, 1];
                                          end;
                                  end
                                  else
                                  begin
                                  v1AIShips[AInr].waypoints[0, 0] := 0;
                                  end;

                          end;

                          if v1AIShips[AInr].waypoints[0, 0] > 0 then
                          begin

                          v1AIShips[AInr].wantedSpeed := v1AIShips[AInr].waypoints[1, 2]; //CHANGE FOR EACH WP?
                                  if v1AIShips[AInr].wantedSpeed > (v1AIShips[AInr].topSpeed - Selv1AISpeedReduction) then //Doublecheck that speed does not exceed topspeed
                                  v1AIShips[AInr].wantedSpeed := (v1AIShips[AInr].topSpeed - Selv1AISpeedReduction);

                                  //Is target dead?
                                  if v1AIShips[AInr].health <= 10 then
                                  v1AIShips[AInr].wantedSpeed := 0;

                          Selv1AIHeadToWP := arctan2(Selv1AIMapMarkerDirPointX - (v1AIShips[AInr].NewPositionX), Selv1AIMapMarkerDirPointY - (v1AIShips[AInr].NewPositionY)) * 180 / pi;
                          //Selv1AIHeadToWP := arctan2(Selv1AIMapMarkerDirPointx - Selv1AIMapMarker.Position.x, Selv1AIMapMarkerDirPointy - Selv1AIMapMarker.Position.y) * 180 / pi;
                          //SelV1AIWantedHeading := Selv1AIHeadToWP * -1;
                          //tempSingZ := SelV1AIWantedHeading - v1AIShips[AInr].Heading;
                          //tempSingZ := SelV1AIWantedHeading - (v1AIShips[AInr].Heading * -1);

                          Selv1AIHeadToWP := Selv1AIHeadToWP - round(Selv1AI.TurnAngle - 180 * -1);
                              if Selv1AIHeadToWP < -180 then
                              begin
                              tempSingZ := round(Selv1AIHeadToWP + 360) * -1;
                              end
                              else
                              begin
                              tempSingZ := round(Selv1AIHeadToWP * -1);
                              end;


                              If tempSingZ <> 0 then
                              begin
                                      If tempSingZ < 0 then
                                      begin
                                              if tempSingZ + 5 < 0 then
                                              begin
                                              Selv1AI.TurnAngle := (Selv1AI.TurnAngle + 0.25 * ((v1AIShips[AInr].speed / 20) * deltaTime * 30 * TC));
                                              end
                                              else
                                              begin
                                                      if tempSingZ + 1 < 0 then
                                                      Selv1AI.TurnAngle := (Selv1AI.TurnAngle + 0.05 * ((v1AIShips[AInr].speed / 20) * deltaTime * 30 * TC));
                                              end;
                                      end;
                                      If tempSingZ > 0 then
                                      begin
                                              if tempSingZ - 5 > 0 then
                                              begin
                                              Selv1AI.TurnAngle := (Selv1AI.TurnAngle - 0.25 * ((v1AIShips[AInr].speed / 20) * deltaTime * 30 * TC));
                                              end
                                              else
                                              begin
                                                      if tempSingZ - 1 > 0 then
                                                      Selv1AI.TurnAngle := (Selv1AI.TurnAngle - 0.05 * ((v1AIShips[AInr].speed / 20) * deltaTime * 30 * TC));
                                              end;
                                      end;
                              end;
                          end
                          else
                          begin
                          v1AIShips[AInr].wantedSpeed := 0;
                          end;



                        Selv1AISmokeEm := GLScene1.FindSceneObject(v1AIShips[AInr].name + 'SmokeEmitter1');
                        Selv1AISmoke := getOrCreateSourcePFX(Selv1AISmokeEm);
                        Selv1AISmokeFXMan := form1.FindComponent(v1AIShips[AInr].name + 'SmokeEmitter1FXman') as TGLPerlinPFXManager;
                        Selv1AIWakeEm := GLScene1.FindSceneObject(v1AIShips[AInr].name + 'WakeEmitter1');
                        Selv1AIWake := getOrCreateSourcePFX(Selv1AIWakeEm);

                            //if v1AIShips[AInr].shipType = 'C2a' then
                            //begin
                            Selv1AIBowWakeEmPrt := GLScene1.FindSceneObject(v1AIShips[AInr].name + 'BowWakeEmitterPrt');
                            Selv1AIBowWakeEmStb := GLScene1.FindSceneObject(v1AIShips[AInr].name + 'BowWakeEmitterStb');
                            Selv1AIBowWakePrt := getOrCreateSourcePFX(Selv1AIBowWakeEmPrt);
                            Selv1AIBowWakeStb := getOrCreateSourcePFX(Selv1AIBowWakeEmStb);
                            //end;

                        //Adjust smoke alpha to fog and distance
                        Selv1AISmokeFXMan.ColorInner.Alpha := 0.8 - ((1 - clampLowSE.value) * (MyShip.DistanceTo(Selv1AISmokeEm) / 40000));
                        Selv1AISmokeFXMan.ColorOuter.Alpha := 0.8 - ((1 - clampLowSE.value) * (MyShip.DistanceTo(Selv1AISmokeEm) / 40000));
                        //Selv1AISmokeFXMan.ColorInner.Alpha := 0.8 - 0.8 * (MyShip.DistanceTo(Selv1AIGermanSmokeEm) / 40000);
                        //Selv1AISmokeFXMan.ColorOuter.Alpha := 0.8 - 0.8 * (MyShip.DistanceTo(Selv1AIGermanSmokeEm) / 40000);

                        if (v1AIShips[AInr].fuel <= 0) or (v1AIShips[AInr].speed < 1) then
                        begin
                                if v1AIShips[AInr].fuel <= 0 then
                                v1AIShips[AInr].wantedSpeed := 0;
                        Selv1AISmoke.ParticleInterval := 0;
                        Selv1AIWake.ParticleInterval := 0;
                            //if v1AIShips[AInr].shipType = 'C2a' then
                            //begin
                            Selv1AIBowWakePrt.ParticleInterval := 0;
                            Selv1AIBowWakeStb.ParticleInterval := 0;
                            //end;
                        end
                        else
                        begin
                        Selv1AISmoke.ParticleInterval := 0.07;
                        Selv1AIWake.ParticleInterval := 0.07;

                            //if v1AIShips[AInr].shipType = 'C2a' then
                            //begin
                            Selv1AIBowWakePrt.ParticleInterval := 0.05;
                            Selv1AIBowWakeStb.ParticleInterval := 0.05;
                            //end;
                        end;

                            if v1AIShips[AInr].stacks > 1 then
                            begin
                            Selv1AISmokeEm2 := GLScene1.FindSceneObject(v1AIShips[AInr].name + 'SmokeEmitter2');
                            Selv1AISmoke2 := getOrCreateSourcePFX(Selv1AISmokeEm);

                                if (v1AIShips[AInr].fuel <= 0) or (v1AIShips[AInr].speed < 1) then
                                begin
                                Selv1AISmoke2.ParticleInterval := 0;
                                end
                                else
                                begin
                                Selv1AISmoke2.ParticleInterval := 0.15;
                                end;
                            end;


                        if v1AIShips[AInr].speed <> v1AIShips[AInr].wantedSpeed then
                        begin
                                if v1AIShips[AInr].speed < v1AIShips[AInr].wantedSpeed then
                                v1AIShips[AInr].speed := v1AIShips[AInr].speed + 0.015 * (deltaTime * 30)
                                else
                                v1AIShips[AInr].speed := v1AIShips[AInr].speed - 0.05 * (deltaTime * 30);
                        end;
                //Selv1AI.Move((v1AIShips[AInr].speed / 10 * -1 * (DeltaTime * 30)) * TC);
                Selv1AI.position.x := (Selv1AI.position.x - cos((Selv1AI.TurnAngle - 90) * pi /180) * (v1AIShips[AInr].speed / 40) * (deltaTime * 60 * TC)); //deltaTime * 120?
                Selv1AI.position.z := (Selv1AI.position.z + sin((Selv1AI.TurnAngle - 90) * pi /180) * (v1AIShips[AInr].speed / 40) * (deltaTime * 60 * TC));

                v1AIShips[AInr].NewPositionX := Selv1AI.position.x + MyShipFictionalPosX;
                v1AIShips[AInr].NewPositionY := Selv1AI.position.z + MyShipFictionalPosZ;
                //Selv1AIMapMarker.Lift((v1AIShips[AInr].speed / 1000 * (DeltaTime * 30)) * TC);
                //Selv1AIMapMarker.RollAngle := Selv1AI.TurnAngle * -1 - 180;

                //v1AIShips[AInr].NewPositionX := Selv1AIMapMarker.Position.X * 100;
                //v1AIShips[AInr].NewPositionY := Selv1AIMapMarker.Position.Y * 100;

                //testAIPosX := (testAIPosX - cos((Selv1AI.TurnAngle - 90) * pi /180) * (v1AIShips[AInr].speed / 4000) * (deltaTime * 30 * TC)); //deltaTime * 120?
                //v1AIShips[AInr].NewPositionX := (v1AIShips[AInr].NewPositionX - cos((Selv1AI.TurnAngle - 90) * pi /180) * (v1AIShips[AInr].speed / 40) * (deltaTime * 60 * TC)); //deltaTime * 120?
                //v1AIShips[AInr].NewPositionY := (v1AIShips[AInr].NewPositionY + sin((Selv1AI.TurnAngle - 90) * pi /180) * (v1AIShips[AInr].speed / 40) * (deltaTime * 60 * TC));

                v1AIShips[AInr].Fuel := v1AIShips[AInr].fuel - (v1AIShips[AInr].speed / 60000); //Handle fuel comsumption

                //If Selv1AIMapMarker.RollAngle < 0 then
                //        v1AIShips[AInr].Heading := Selv1AIMapMarker.RollAngle + 360
                //        else
                //        v1AIShips[AInr].Heading := Selv1AIMapMarker.RollAngle;
                //

                tempSingZ := Selv1AI.TurnAngle * -1 - 180;

                        If tempSingZ < 0 then
                        v1AIShips[AInr].Heading := tempSingZ + 360
                        else
                        v1AIShips[AInr].Heading := tempSingZ;

                //v1AIShips[AInr].PositionX := Selv1AI.Position.X / 100;
                //v1AIShips[AInr].PositionY := Selv1AI.Position.Z / 100;

                end;

                if v1AiShips[AInr].isSpotted = false then
                begin
                tempSingZ := MyShip.DistanceTo(Selv1AI);
                     if v1AiShips[AInr].spotableDistance * 4 > tempSingZ then
                     begin
                     tctb.Position := 1;
                     v1AiShips[AInr].isSpotted := true;
                     missionLogMemo.Lines.Insert(0, 'Ship spotted, sir!');
                     missionLogMemo.Lines.Insert(0, 'Range: ' + intToStr(round(tempSingZ / 4000))+ 'km');
                     end;
                end;

                //BATTLE STUFF
                if (v1AIShips[AInr].guns > 0) and (v1AIShips[AInr].Health < 15) then
                begin

                selv1AIGunASmokeEmit := glScene1.FindSceneObject(v1AIShips[AInr].name + 'GunASmokeEmit');
                selv1AIGunASmoke := getOrCreatesOURCEpFX(selv1AIGunASmokeEmit);
                selv1AIGunAFireEmit := glScene1.FindSceneObject(v1AIShips[AInr].name + 'GunAFireEmit');
                //selv1AIGunAFire := getOrCreateSourcePFX(selv1AIGunAFireEmit);
                //selv1AIGunFireSpriteA := glScene1.FindSceneObject(v1AIShips[AInr].name + 'ExplSpriteA') as tglSprite;
                selv1AIGunASmoke.ParticleInterval := 0;
                //selv1AIGunAFire.ParticleInterval := 0;

                    if (v1AIShips[AInr].guns > 1) then
                    begin
                    selv1AIGunBSmokeEmit := glScene1.FindSceneObject(v1AIShips[AInr].name + 'GunBSmokeEmit');
                    selv1AIGunBSmoke := getOrCreatesOURCEpFX(selv1AIGunBSmokeEmit);
                    selv1AIGunBFireEmit := glScene1.FindSceneObject(v1AIShips[AInr].name + 'GunBFireEmit');
                    //selv1AIGunBFire := getOrCreateSourcePFX(selv1AIGunBFireEmit);
                    selv1AIGunBSmoke.ParticleInterval := 0;
                    //selv1AIGunBFire.ParticleInterval := 0;
                    //selv1AIGunFireSpriteB := glScene1.FindSceneObject(v1AIShips[AInr].name + 'ExplSpriteB') as tglSprite;

                          if (v1AIShips[AInr].guns > 2) then
                          begin
                          selv1AIGunCSmokeEmit := glScene1.FindSceneObject(v1AIShips[AInr].name + 'GunCSmokeEmit');
                          selv1AIGunCSmoke := getOrCreatesOURCEpFX(selv1AIGunCSmokeEmit);
                          selv1AIGunCFireEmit := glScene1.FindSceneObject(v1AIShips[AInr].name + 'GunCFireEmit');
                          //selv1AIGunCFire := getOrCreateSourcePFX(selv1AIGunCFireEmit);
                          selv1AIGunCSmoke.ParticleInterval := 0;
                          //selv1AIGunCFire.ParticleInterval := 0;
                          //selv1AIGunFireSpriteC := glScene1.FindSceneObject(v1AIShips[AInr].name + 'ExplSpriteC') as tglSprite;

                                if (v1AIShips[AInr].guns > 3) then
                                begin
                                selv1AIGunDSmokeEmit := glScene1.FindSceneObject(v1AIShips[AInr].name + 'GunDSmokeEmit');
                                selv1AIGunDSmoke := getOrCreatesOURCEpFX(selv1AIGunDSmokeEmit);
                                selv1AIGunDFireEmit := glScene1.FindSceneObject(v1AIShips[AInr].name + 'GunDFireEmit');
                                //selv1AIGunDFire := getOrCreateSourcePFX(selv1AIGunDFireEmit);
                                selv1AIGunDSmoke.ParticleInterval := 0;
                                //selv1AIGunDFire.ParticleInterval := 0;
                                //selv1AIGunFireSpriteD := glScene1.FindSceneObject(v1AIShips[AInr].name + 'ExplSpriteD') as tglSprite;

                                end;
                          end;
                    end;

                end;

                if (v1AIShips[AInr].guns > 0) and (v1AIShips[AInr].Health > 15) and (v1AIShips[AInr].enabled = true) then
                begin
                selv1AIGunA := GLScene1.FindSceneObject(v1AIShips[AInr].name + 'GunA');
                selv1AIGunB := GLScene1.FindSceneObject(v1AIShips[AInr].name + 'GunB');
                selv1AIGunC := GLScene1.FindSceneObject(v1AIShips[AInr].name + 'GunC');
                    if v1AIShips[AInr].guns > 3 then
                    selv1AIGunD := GLScene1.FindSceneObject(v1AIShips[AInr].name + 'GunD');

                selv1AIGunAFireEmit := glScene1.FindSceneObject(v1AIShips[AInr].name + 'GunAFireEmit');
                selv1AIGunFireSpriteA := glScene1.FindSceneObject(v1AIShips[AInr].name + 'ExplSpriteA') as tglSprite;
                selv1AIGunFireSpriteA.AbsolutePosition := selv1AIGunAFireEmit.AbsolutePosition;
                    if selv1AIGunFireSpriteA.visible = true then
                    begin
                         if selv1AIGunFireSpriteA.Material.LibMaterialName = '16' then
                         begin
                         selv1AIGunFireSpriteA.visible := false;
                         //selv1AIGunFireSpriteA.Material.LibMaterialName := '';
                         end
                         else
                         begin
                         tempIntX := strToInt(selv1AIGunFireSpriteA.Material.LibMaterialName);
                         selv1AIGunFireSpriteA.Material.LibMaterialName := intToStr(tempIntX + 1);
                         end;
                     end;

                selv1AIGunASmokeEmit := glScene1.FindSceneObject(v1AIShips[AInr].name + 'GunASmokeEmit');
                selv1AIGunASmoke := getOrCreatesOURCEpFX(selv1AIGunASmokeEmit);
                //selv1AIGunAFireEmit := glScene1.FindSceneObject(v1AIShips[AInr].name + 'GunAFireEmit');
                //selv1AIGunAFire := getOrCreateSourcePFX(selv1AIGunAFireEmit);

                        if (selv1AIGunASmoke.ParticleInterval < 1) and (selv1AIGunASmoke.ParticleInterval <> 0) then
                        selv1AIGunASmoke.ParticleInterval := selv1AIGunASmoke.ParticleInterval + 0.0025
                        else
                        selv1AIGunASmoke.ParticleInterval := 0;

                        //if (selv1AIGunAFire.ParticleInterval < 1) and (selv1AIGunAFire.ParticleInterval <> 0) then
                        //selv1AIGunAFire.ParticleInterval := selv1AIGunAFire.ParticleInterval + 0.25
                        //else
                        //selv1AIGunAFire.ParticleInterval := 0;

                selv1AIGunBFireEmit := glScene1.FindSceneObject(v1AIShips[AInr].name + 'GunBFireEmit');
                selv1AIGunFireSpriteB := glScene1.FindSceneObject(v1AIShips[AInr].name + 'ExplSpriteB') as tglSprite;
                selv1AIGunFireSpriteB.AbsolutePosition := selv1AIGunBFireEmit.AbsolutePosition;
                    if selv1AIGunFireSpriteB.visible = true then
                    begin
                         if selv1AIGunFireSpriteB.Material.LibMaterialName = '16' then
                         begin
                         selv1AIGunFireSpriteB.visible := false;
                         //selv1AIGunFireSpriteA.Material.LibMaterialName := '';
                         end
                         else
                         begin
                         tempIntX := strToInt(selv1AIGunFireSpriteB.Material.LibMaterialName);
                         selv1AIGunFireSpriteB.Material.LibMaterialName := intToStr(tempIntX + 1);
                         end;
                     end;
                selv1AIGunBSmokeEmit := glScene1.FindSceneObject(v1AIShips[AInr].name + 'GunBSmokeEmit');
                selv1AIGunBSmoke := getOrCreatesOURCEpFX(selv1AIGunBSmokeEmit);
                selv1AIGunBFireEmit := glScene1.FindSceneObject(v1AIShips[AInr].name + 'GunBFireEmit');
                //selv1AIGunBFire := getOrCreateSourcePFX(selv1AIGunBFireEmit);

                        if (selv1AIGunBSmoke.ParticleInterval < 1) and (selv1AIGunBSmoke.ParticleInterval <> 0) then
                        selv1AIGunBSmoke.ParticleInterval := selv1AIGunBSmoke.ParticleInterval + 0.0025
                        else
                        selv1AIGunBSmoke.ParticleInterval := 0;

                        //if (selv1AIGunBFire.ParticleInterval < 1) and (selv1AIGunBFire.ParticleInterval <> 0) then
                        //selv1AIGunBFire.ParticleInterval := selv1AIGunBFire.ParticleInterval + 0.25
                        //else
                        //selv1AIGunBFire.ParticleInterval := 0;
                selv1AIGunCFireEmit := glScene1.FindSceneObject(v1AIShips[AInr].name + 'GunCFireEmit');
                selv1AIGunFireSpriteC := glScene1.FindSceneObject(v1AIShips[AInr].name + 'ExplSpriteC') as tglSprite;
                selv1AIGunFireSpriteC.AbsolutePosition := selv1AIGunCFireEmit.AbsolutePosition;
                    if selv1AIGunFireSpriteC.visible = true then
                    begin
                         if selv1AIGunFireSpriteC.Material.LibMaterialName = '16' then
                         begin
                         selv1AIGunFireSpriteC.visible := false;
                         //selv1AIGunFireSpriteA.Material.LibMaterialName := '';
                         end
                         else
                         begin
                         tempIntX := strToInt(selv1AIGunFireSpriteC.Material.LibMaterialName);
                         selv1AIGunFireSpriteC.Material.LibMaterialName := intToStr(tempIntX + 1);
                         end;
                     end;
                selv1AIGunCSmokeEmit := glScene1.FindSceneObject(v1AIShips[AInr].name + 'GunCSmokeEmit');
                selv1AIGunCSmoke := getOrCreatesOURCEpFX(selv1AIGunCSmokeEmit);
                selv1AIGunCFireEmit := glScene1.FindSceneObject(v1AIShips[AInr].name + 'GunCFireEmit');
                //selv1AIGunCFire := getOrCreateSourcePFX(selv1AIGunCFireEmit);

                        if (selv1AIGunCSmoke.ParticleInterval < 1) and (selv1AIGunCSmoke.ParticleInterval <> 0) then
                        selv1AIGunCSmoke.ParticleInterval := selv1AIGunCSmoke.ParticleInterval + 0.0025
                        else
                        selv1AIGunCSmoke.ParticleInterval := 0;

                        //if (selv1AIGunCFire.ParticleInterval < 1) and (selv1AIGunCFire.ParticleInterval <> 0) then
                        //selv1AIGunCFire.ParticleInterval := selv1AIGunCFire.ParticleInterval + 0.25
                        //else
                        //selv1AIGunCFire.ParticleInterval := 0;

                    if v1AIShips[AInr].guns > 3 then
                    begin
                    selv1AIGunDFireEmit := glScene1.FindSceneObject(v1AIShips[AInr].name + 'GunDFireEmit');
                    selv1AIGunFireSpriteD := glScene1.FindSceneObject(v1AIShips[AInr].name + 'ExplSpriteD') as tglSprite;
                    selv1AIGunFireSpriteD.AbsolutePosition := selv1AIGunDFireEmit.AbsolutePosition;
                        if selv1AIGunFireSpriteD.visible = true then
                        begin
                             if selv1AIGunFireSpriteD.Material.LibMaterialName = '16' then
                             begin
                             selv1AIGunFireSpriteD.visible := false;
                             //selv1AIGunFireSpriteA.Material.LibMaterialName := '';
                             end
                             else
                             begin
                             tempIntX := strToInt(selv1AIGunFireSpriteD.Material.LibMaterialName);
                             selv1AIGunFireSpriteD.Material.LibMaterialName := intToStr(tempIntX + 1);
                             end;
                         end;

                    selv1AIGunDSmokeEmit := glScene1.FindSceneObject(v1AIShips[AInr].name + 'GunDSmokeEmit');
                    selv1AIGunDSmoke := getOrCreatesOURCEpFX(selv1AIGunDSmokeEmit);
                    selv1AIGunDFireEmit := glScene1.FindSceneObject(v1AIShips[AInr].name + 'GunDFireEmit');
                    //selv1AIGunDFire := getOrCreateSourcePFX(selv1AIGunDFireEmit);

                            if (selv1AIGunDSmoke.ParticleInterval < 1) and (selv1AIGunDSmoke.ParticleInterval <> 0) then
                            selv1AIGunDSmoke.ParticleInterval := selv1AIGunDSmoke.ParticleInterval + 0.0025
                            else
                            selv1AIGunDSmoke.ParticleInterval := 0;

                            //if (selv1AIGunDFire.ParticleInterval < 1) and (selv1AIGunDFire.ParticleInterval <> 0) then
                            //selv1AIGunDFire.ParticleInterval := selv1AIGunDFire.ParticleInterval + 0.25
                            //else
                            //selv1AIGunDFire.ParticleInterval := 0;
                    end;

             if battleEnableCB.checked = true then
             begin

                //Lets check if target is still valid
                if (v1AIShips[AInr].hasTarget = true) then
                begin
                    if v1AIShips[AInr].IsTargetPlayer = true then
                    begin
                    selv1AIdistToTarget := Selv1AI.DistanceTo(myShip);

                          if selv1AIdistToTarget > v1AIShips[AInr].DetectionRange then
                          begin
                          v1AIShips[AInr].hasTarget := false;
                          v1AIShips[AInr].IsTargetPlayer := false;
                          end
                          else
                          begin
                          Selv1AITarget := GLScene1.FindSceneObject('MyShip');
                          v1AIShips[AInr].IsTargetPlayer := true;
                          v1AIShips[AInr].HasTarget := true;
                          end;
                    end
                    else
                    begin
                        if v1AIGermancounter > 0 then
                        begin
                               For tempIntX := 1 to v1AIGermancounter do
                               begin
                                    if v1AIGermanShips[tempIntX].ID = v1AiShips[AInr].TargetID then
                                    tempIntZ := tempIntX;
                               end;

                               if v1AIGermanShips[tempIntZ].health < 1 then
                               v1AIShips[AInr].hasTarget := false;

                          Selv1AITarget := GLScene1.FindSceneObject(v1AIShips[AInr].TargetObject);
                          selv1AIdistToTarget := Selv1AI.DistanceTo(Selv1AITarget);

                              if selv1AIdistToTarget > v1AIShips[AInr].DetectionRange then
                              v1AIShips[AInr].hasTarget := false;
                          end
                          else
                          begin
                          v1AIShips[AInr].hasTarget := false;
                          end;
                    end;
                end
                else
                begin
                     //If we do not have a target, search for one.
                    if v1AIGermancounter > 0 then
                    begin
                    AITargetTempList := TStringList.Create;
                           For tempIntX := 1 to v1AIGermancounter do
                           begin

                                Selv1AITarget := GLScene1.FindSceneObject(v1AIGermanShips[tempIntX].name);
                                   if v1AiGermanShips[tempIntX].health > 0 then
                                   begin
                                   selv1AIdistToTarget := Selv1AI.DistanceTo(Selv1AITarget);
                                        if selv1AIdistToTarget < v1AIShips[AInr].DetectionRange then
                                        begin
                                        AITargetTempList.Append(intToStr(v1AiGermanShips[tempIntX].ID));
                                        end;
                                   end;

                           end;

                           if AITargetTempList.Count > 0 then
                           begin

                           //Check if player also is a valid target
                           selv1AIdistToTarget := Selv1AI.DistanceTo(myShip); //Kanske inte varje gång? Dyrt.

                               if selv1AIdistToTarget < v1AIShips[AInr].DetectionRange then
                               begin
                               tempIntA := GLS_RNG.Random(100);
                               end
                               else
                               begin
                               tempIntA := 0;
                               end;

                           tempIntX := AITargetTempList.Count;
                           tempIntZ := GLS_RNG.Random(tempIntX);

                           v1AIShips[AInr].hasTarget := true;
                           v1AIShips[AInr].SolutionTimer := GLS_RNG.Random(180) + 30;

                               if tempIntA <= (100 / (tempIntX + 1)) then
                               begin
                               //player
                               Selv1AITarget := GLScene1.FindSceneObject('myShip');
                               v1AIShips[AInr].TargetObject := 'myShip';
                               v1AIShips[AInr].IsTargetPlayer := true;
                               end
                               else
                               begin
                               v1AIShips[AInr].TargetID := strToInt(AITargetTempList.Strings[tempIntZ]);
                               //v1AIGermanShips[AInr].TargetID := strToInt(AITargetTempList.ValueFromIndex[tempIntZ]);
                                   For tempIntX := 1 to v1AIGermancounter do
                                   begin
                                        if v1AIShips[AInr].TargetID = v1AiGermanShips[tempIntX].ID then
                                        v1AIShips[AInr].TargetObject := v1AiGermanShips[tempIntX].name;
                                   end;
                               //v1AIGermanShips[AInr].TargetObject := AITargetTempList.Names[tempIntZ];
                               Selv1AITarget := GLScene1.FindSceneObject(v1AIShips[AInr].TargetObject);
                               v1AIShips[AInr].IsTargetPlayer := false;
                               end;
                           end;
                      AITargetTempList.Free;
                    end
                    else
                    begin
                    //If no other AI's, check player as a target
                    selv1AIdistToTarget := Selv1AI.DistanceTo(myShip);

                               if selv1AIdistToTarget < v1AIShips[AInr].DetectionRange then
                               begin
                               Selv1AITarget := GLScene1.FindSceneObject('MyShip');
                               v1AIShips[AInr].IsTargetPlayer := true;
                               v1AIShips[AInr].HasTarget := true;
                               v1AIShips[AInr].SolutionTimer := GLS_RNG.Random(180) + 30;
                               end
                               else
                               begin
                               v1AIShips[AInr].IsTargetPlayer := false;
                               v1AIShips[AInr].HasTarget := false;
                               end;
                    end;
                  end;
               end;

                //Now we have a target or not

            If (v1AIShips[AInr].hasTarget = true) and (v1AIShips[AInr].SolutionTimer < 1) then
            begin

                 //if v1AIShips[AInr].IsTargetPlayer = true then
                 //begin
                 //tempSingX := arctan2(myShip.Position.x - Selv1AI.Position.x, myShip.Position.z - Selv1AI.Position.z) * 180 / pi;
                 //end
                 //else
                 //begin
            tempSingX := arctan2(Selv1AITarget.Position.x - Selv1AI.Position.x, Selv1AITarget.Position.z - Selv1AI.Position.z) * 180 / pi;
                 //end;

            tempSingX := tempSingX - round(Selv1AI.TurnAngle - 180 * -1);
                    if tempSingX < -180 then
                    selv1AIdirToTarget := round(tempSingX + 360) * -1
                    else
                    selv1AIdirToTarget := round(tempSingX * -1);

                    if round(v1AIShips[AInr].GunAdir) <> selv1AIdirToTarget then
                    begin
                    GunAReady := False;
                      if round(v1AIShips[AInr].GunAdir) < selv1AIdirToTarget then
                      begin
                              if (selv1AIdirToTarget < 131) and (selv1AIdirToTarget > -131) then
                              v1AIShips[AInr].GunAdir := v1AIShips[AInr].GunAdir + 0.4;
                      end
                      else
                      begin
                              if (selv1AIdirToTarget < 131) and (selv1AIdirToTarget > -131) then
                              v1AIShips[AInr].GunAdir := v1AIShips[AInr].GunAdir - 0.4;
                      end;
                    end
                    else
                    begin
                    GunAReady := true;
                    end;

                    if v1AIShips[AInr].GunAdir > 130 then
                    v1AIShips[AInr].GunAdir := 130;

                    if v1AIShips[AInr].GunAdir < -130 then
                    v1AIShips[AInr].GunAdir := -130;

                    if round(v1AIShips[AInr].GunBdir) <> selv1AIdirToTarget then
                    begin
                    GunBReady := False;
                      if round(v1AIShips[AInr].GunBdir) < selv1AIdirToTarget then
                      begin
                              if (selv1AIdirToTarget < 131) and (selv1AIdirToTarget > -131) then
                              v1AIShips[AInr].GunBdir := v1AIShips[AInr].GunBdir + 0.4;
                      end
                      else
                      begin
                              if (selv1AIdirToTarget < 131) and (selv1AIdirToTarget > -131) then
                              v1AIShips[AInr].GunBdir := v1AIShips[AInr].GunBdir - 0.4;
                      end;
                    end
                    else
                    begin
                    GunBReady := true;
                    end;

                    if v1AIShips[AInr].GunBdir > 130 then
                    v1AIShips[AInr].GunBdir := 130;

                    if v1AIShips[AInr].GunBdir < -130 then
                    v1AIShips[AInr].GunBdir := -130;

                    if v1AIShips[AInr].shipType = 'Nelson' then
                    begin
                        if round(v1AIShips[AInr].GunCdir) <> selv1AIdirToTarget then
                        begin
                        GunCReady := False;
                          if round(v1AIShips[AInr].GunCdir) < selv1AIdirToTarget then
                          begin
                                  if (selv1AIdirToTarget < 131) and (selv1AIdirToTarget > -131) then
                                  v1AIShips[AInr].GunCdir := v1AIShips[AInr].GunCdir + 0.4;
                          end
                          else
                          begin
                                  if (selv1AIdirToTarget < 131) and (selv1AIdirToTarget > -131) then
                                  v1AIShips[AInr].GunCdir := v1AIShips[AInr].GunCdir - 0.4;
                          end;
                        end
                        else
                        begin
                        GunCReady := true;
                        end;

                        if v1AIShips[AInr].GunCdir > 130 then
                        v1AIShips[AInr].GunCdir := 130;

                        if v1AIShips[AInr].GunCdir < -130 then
                        v1AIShips[AInr].GunCdir := -130;
                    end
                    else
                    begin
                        if round(v1AIShips[AInr].GunCdir) <> selv1AIdirToTarget then
                        begin
                        GunCReady := false;
                          if v1AIShips[AInr].GunCdir > 0 then
                          begin
                              if round(v1AIShips[AInr].GunCdir) < selv1AIdirToTarget then
                              begin
                                      if (selv1AIdirToTarget < 180) and (selv1AIdirToTarget > 50) then
                                      v1AIShips[AInr].GunCdir := v1AIShips[AInr].GunCdir + 0.4;

                              end
                              else
                              begin
                                      if (selv1AIdirToTarget < 180) and (selv1AIdirToTarget > 50) then
                                      v1AIShips[AInr].GunCdir := v1AIShips[AInr].GunCdir - 0.4;

                                      if (selv1AIdirToTarget > -180) and (selv1AIdirToTarget < -50) then
                                      v1AIShips[AInr].GunCdir := v1AIShips[AInr].GunCdir + 0.4;
                              end;
                          end
                          else
                          begin
                              if round(v1AIShips[AInr].GunCdir) < selv1AIdirToTarget then
                              begin
                                      if (selv1AIdirToTarget < -50) and (selv1AIdirToTarget > -180) then
                                      v1AIShips[AInr].GunCdir := v1AIShips[AInr].GunCdir + 0.4;

                                      if (selv1AIdirToTarget < 180) and (selv1AIdirToTarget > 50) then
                                      v1AIShips[AInr].GunCdir := v1AIShips[AInr].GunCdir - 0.4;

                              end
                              else
                              begin
                                      if (selv1AIdirToTarget > -180) and (selv1AIdirToTarget < -50) then
                                      v1AIShips[AInr].GunCdir := v1AIShips[AInr].GunCdir - 0.4;
                              end;
                          end;
                        end
                        else
                        begin
                        GunCReady := true;
                        end;

                        if v1AIShips[AInr].GunCdir > 180 then
                        v1AIShips[AInr].GunCdir := v1AIShips[AInr].GunCdir - 360;

                        if (v1AIShips[AInr].GunCdir < 50) and (v1AIShips[AInr].GunCdir > 0) then
                        v1AIShips[AInr].GunCdir := 50;

                        if (v1AIShips[AInr].GunCdir > -50) and (v1AIShips[AInr].GunCdir < 0) then
                        v1AIShips[AInr].GunCdir := -50;
                    end;

                    if v1AIShips[AInr].Guns > 3 then
                    begin
                        if round(v1AIShips[AInr].GunDdir) <> selv1AIdirToTarget then
                        begin
                        GunDReady := false;
                          if v1AIShips[AInr].GunDdir > 0 then
                          begin
                              if round(v1AIShips[AInr].GunDdir) < selv1AIdirToTarget then
                              begin
                                      if (selv1AIdirToTarget < 180) and (selv1AIdirToTarget > 50) then
                                      v1AIShips[AInr].GunDdir := v1AIShips[AInr].GunDdir + 0.4;

                              end
                              else
                              begin
                                      if (selv1AIdirToTarget < 180) and (selv1AIdirToTarget > 50) then
                                      v1AIShips[AInr].GunDdir := v1AIShips[AInr].GunDdir - 0.4;

                                      if (selv1AIdirToTarget > -180) and (selv1AIdirToTarget < -50) then
                                      v1AIShips[AInr].GunDdir := v1AIShips[AInr].GunDdir + 0.4;
                              end;
                          end
                          else
                          begin
                              if round(v1AIShips[AInr].GunDdir) < selv1AIdirToTarget then
                              begin
                                      if (selv1AIdirToTarget < -50) and (selv1AIdirToTarget > -180) then
                                      v1AIShips[AInr].GunDdir := v1AIShips[AInr].GunDdir + 0.4;

                                      if (selv1AIdirToTarget < 180) and (selv1AIdirToTarget > 50) then
                                      v1AIShips[AInr].GunDdir := v1AIShips[AInr].GunDdir - 0.4;

                              end
                              else
                              begin
                                      if (selv1AIdirToTarget > -180) and (selv1AIdirToTarget < -50) then
                                      v1AIShips[AInr].GunDdir := v1AIShips[AInr].GunDdir - 0.4;
                              end;
                          end;
                        end
                        else
                        begin
                        GunDReady := true;
                        end;

                        if v1AIShips[AInr].GunDdir > 180 then
                        v1AIShips[AInr].GunDdir := v1AIShips[AInr].GunDdir - 360;

                        if (v1AIShips[AInr].GunDdir < 50) and (v1AIShips[AInr].GunDdir > 0) then
                        v1AIShips[AInr].GunDdir := 50;

                        if (v1AIShips[AInr].GunDdir > -50) and (v1AIShips[AInr].GunDdir < 0) then
                        v1AIShips[AInr].GunDdir := -50;
                    end;

                    Selv1AIGunAAimBox2 := glScene1.FindSceneObject(v1AIShips[AInr].name + 'GunAAimBox2');
                    Selv1AIGunAAimBox2.Position.Z := selv1AIGunA.DistanceTo(Selv1AITarget) * -1 / v1AIShips[AInr].scale;
                    Selv1AIGunBAimBox2 := glScene1.FindSceneObject(v1AIShips[AInr].name + 'GunBAimBox2');
                    Selv1AIGunBAimBox2.Position.Z := selv1AIGunB.DistanceTo(Selv1AITarget) * -1 / v1AIShips[AInr].scale;
                    Selv1AIGunCAimBox2 := glScene1.FindSceneObject(v1AIShips[AInr].name + 'GunCAimBox2');
                    Selv1AIGunCAimBox2.Position.Z := selv1AIGunC.DistanceTo(Selv1AITarget) * -1 / v1AIShips[AInr].scale;
                        if v1AIShips[AInr].guns > 3 then
                        begin
                        Selv1AIGunDAimBox2 := glScene1.FindSceneObject(v1AIShips[AInr].name + 'GunDAimBox2');
                        Selv1AIGunDAimBox2.Position.Z := selv1AIGunD.DistanceTo(Selv1AITarget) * -1 / v1AIShips[AInr].scale;
                        end;

            Selv1AIGunPlotAccuracy := round(100 * ((selv1AIdistToTarget / 4) / v1AIShips[AInr].DetectionRange));

                    if selv1AIGunA.TurnAngle = v1AIShips[AInr].GunAdir * -1 then
                    begin

                            if (v1AIShips[AInr].GunART <= 0) and (v1AIShips[AInr].MainGunAmmo > v1AIShips[AInr].TurretAGunCount) and (GunAReady = True) then
                            begin

                                 if TCTB.Position > 1 then
                                 tctb.Position := 1;

                            selv1AIGunASmokeEmit := glScene1.FindSceneObject(v1AIShips[AInr].name + 'GunASmokeEmit');
                            selv1AIGunASmoke := getOrCreateSourcePFX(selv1AIGunASmokeEmit);
                            selv1AIGunASmoke.ParticleInterval := 0.001;
                                if v1AIShips[AInr].shipType = 'Nelson' then
                                begin
                                v1AIShips[AInr].GunART := 1500;
                                end
                                else
                                begin
                                v1AIShips[AInr].GunART := 1200;
                                end;
                            selv1AIGunAFireEmit := glScene1.FindSceneObject(v1AIShips[AInr].name + 'GunAFireEmit');
                            selv1AIGunFireSpriteA := glScene1.FindSceneObject(v1AIShips[AInr].name + 'ExplSpriteA') as tglSprite;

                            selv1AIGunFireSpriteA.Material.LibMaterialName := '1';
                            selv1AIGunFireSpriteA.visible := true;
                            //selv1AIGunAFire := getOrCreateSourcePFX(selv1AIGunAFireEmit);
                            //selv1AIGunAFire.ParticleInterval := 0.0005;
                            v1AIShips[AInr].MainGunAmmo := v1AIShips[AInr].MainGunAmmo - v1AIShips[AInr].TurretAGunCount;
                            //selv1AIGunAFireEmit.ShowAxes := true;

                            for tempIntZ := 0 to v1AIShips[AInr].TurretAGunCount - 1 do
                            begin
                            v1AIRound_type1 := TGLCone(AIGunRoundHolder.AddNewChild(TGLCone));

                            v1AIFlyingRoundsCounter := v1AIFlyingRoundsCounter + 1;
                            v1AIRound_type1.Name := selv1AI.Name + 'v1AIRound_typeI' + intToStr(v1AIFlyingRoundsCounter);
                            v1AIRound_type1.AbsolutePosition := selv1AIGunAFireEmit.AbsolutePosition;
                            v1AIRound_type1.AbsoluteDirection := selv1AIGunAFireEmit.AbsoluteDirection;
                            v1AIRound_type1.Material.FrontProperties.Emission.SetColor(1,0,0,1);
                            v1AIRound_type1.Up.Z := 1;
                            //v1AIRound_type1.Up.X := 0;
                            v1AIRound_type1.Up.Y := 0;
                            //v1AIRound_type1.ShowAxes := true;


                                    //With GetOrCreateCollision(v1AIRound_type1) Do
                                    //begin
                                    //BoundingMode:=cbmCube;
                                    //Manager:=v1AIRoundCollMan;
                                    //end;

                            Selv1AIGunAAimBox := glScene1.FindSceneObject(v1AIShips[AInr].name + 'GunAAimBox');
                            //Selv1AIGunAAimBox.ShowAxes := true;
                            //Selv1AIGunANodes := glScene1.FindSceneObject(v1AIShips[AInr].name + 'GunA1Nodes');
                                case tempIntZ of
                                 0: Selv1AIGunANodes := glScene1.FindSceneObject(v1AIShips[AInr].name + 'GunA1Nodes');
                                 1: Selv1AIGunANodes := glScene1.FindSceneObject(v1AIShips[AInr].name + 'GunA2Nodes');
                                 2: Selv1AIGunANodes := glScene1.FindSceneObject(v1AIShips[AInr].name + 'GunA3Nodes');
                                 end;

                            Selv1AIGunANodes.Visible := EtrajCB.Checked;

                            Selv1AIGunAAimBox.Position.X := 0 + GLS_RNG.Random(4) - 2 + (GLS_RNG.Random(Selv1AIGunPlotAccuracy) - (Selv1AIGunPlotAccuracy / 2));
                            Selv1AIGunAAimBox.Position.Z := 0 + GLS_RNG.Random(4) - 2 + (GLS_RNG.Random(Selv1AIGunPlotAccuracy) - (Selv1AIGunPlotAccuracy / 2));

                            v1AI_type1path_dummy.AbsolutePosition := v1AIRound_type1.AbsolutePosition;
                            v1AI_type1path_dummy2.AbsolutePosition := Selv1AIGunAAimBox.AbsolutePosition;
                                    with Selv1AIGunANodes as TGLLines do
                                    begin
                                    nodes.Clear;
                                    AddNode(v1AI_type1path_dummy.Position.X,v1AI_type1path_dummy.Position.y,v1AI_type1path_dummy.Position.z);
                                    SplineMode := lsmCubicSpline;
                                    end;

                            tempVector := v1AI_type1path_dummy.AbsolutePosition;

                            v1AIRound_type1_Move := GetOrCreateMovement(v1AIRound_type1);
                            v1AIRound_type1_Move.ClearPaths;
                            v1AIRound_type1_Path := v1AIRound_type1_Move.AddPath;
                            v1AIRound_type1_Path.Name := v1AIRound_type1.name + 'Path';
                            v1AIRound_type1_Path.Nodes.Clear;
                            v1AIRound_type1_Node := v1AIRound_type1_Path.AddNode;

                            v1AIRound_type1_Node.PositionAsVector := tempVector;
                            v1AIRound_type1_Node.Speed := (4000);

                            tempSingX := (v1AI_type1path_dummy2.Position.X + v1AI_type1path_dummy.Position.X) * 0.50;
                            tempSingY := (v1AI_type1path_dummy2.Position.Y + v1AI_type1path_dummy.Position.Y) * 0.50;
                            tempSingZ := (v1AI_type1path_dummy2.Position.Z + v1AI_type1path_dummy.Position.Z) * 0.50;

                            with Selv1AIGunANodes as TGLLines do
                            begin
                            AddNode(tempSingX,tempSingy + (selv1AIGunAFireEmit.distanceTo(Selv1AIGunAAimBox)/100),tempSingz);
                            end;

                            v1AIRound_type1_Node := v1AIRound_type1_Path.AddNode;
                            v1AIRound_type1_Node.X := tempSingX;
                            v1AIRound_type1_Node.Y := tempSingy + (selv1AIGunAFireEmit.distanceTo(Selv1AIGunAAimBox)/100);
                            v1AIRound_type1_Node.Z := tempSingz;
                            //v1AIRound_type1_Node.PositionAsVector := Selv1AIGunAAimBox.AbsolutePosition;
                            v1AIRound_type1_Node.Speed := (4000);

                            v1AIRound_type1_Node := v1AIRound_type1_Path.AddNode;
                            v1AIRound_type1_Node.X := v1AI_type1path_dummy2.Position.X;
                            v1AIRound_type1_Node.Y := 0; //v1AI_type1path_dummy2.Position.Y;
                            v1AIRound_type1_Node.Z := v1AI_type1path_dummy2.Position.Z;
                            v1AIRound_type1_Node.Speed := (4000);

                                    with Selv1AIGunANodes as TGLLines do
                                    begin
                                    AddNode(v1AI_type1path_dummy2.Position.X, 0,v1AI_type1path_dummy2.Position.z);
                                    end;

                            v1AIRound_type1_Move.ActivePath := v1AIRound_type1_Path;
                            v1AIRound_type1_Move.ActivePathIndex := 0;

                                    if Assigned(v1AIRound_type1_Move) then
                                    v1AIRound_type1_Move.StartPathTravel;
                            v1AIRound_type1_Move.OnPathTravelStop := v1AIRoundPathTravelStop;
                            end;

                            //mySFX := OALManager.Add('Sounds/EnemyFire1.wav');
                            mySFX.Volume.value := 1000 - 999 * (cameraCube.DistanceTo(selv1AIGunASmokeEmit) / 100000);
                            mySFX := OALManager.GetSoundByIndex(mySFXEnemyFireIndex + mySFXEnemyFireCount);
                            mySFX.Pitch.Value := 1 + (((GLS_RNG.Random(10)) - 5) * 0.1);
                            mySFX.play;

                                     if mySFXEnemyFireCount >= mySFXEnemyFireMax - 1 then
                                     begin
                                     mySFXEnemyFireCount := 0;
                                     end
                                     else
                                     begin
                                     mySFXEnemyFireCount := mySFXEnemyFireCount + 1;
                                     end;

                               //Selv1AIGunASoundFX := getOrCreateSoundEmitter(selv1AIGunASmokeEmit);
                               // Selv1AIGunASoundFX.Source.SoundLibrary:=SoundLib1;
                               // Selv1AIGunASoundFX.Source.SoundName:='EnemyFire1SFX';
                               // Selv1AIGunASoundFX.source.MaxDistance := 100;
                               // Selv1AIGunASoundFX.source.ConeOutsideVolume := 0.5;
                               // Selv1AIGunASoundFX.Playing:=True;



                            end;
                    end;

                    if selv1AIGunB.TurnAngle = v1AIShips[AInr].GunBdir * -1 then
                    begin
                            if (v1AIShips[AInr].GunBRT <= 0) and (v1AIShips[AInr].MainGunAmmo > v1AIShips[AInr].TurretBGunCount - 1) and (GunBReady = True) then
                            begin

                                 if TCTB.Position > 1 then
                                 tctb.Position := 1;
                            selv1AIGunBSmokeEmit := glScene1.FindSceneObject(v1AIShips[AInr].name + 'GunBSmokeEmit');
                            selv1AIGunBSmoke := getOrCreateSourcePFX(selv1AIGunBSmokeEmit);
                            selv1AIGunBSmoke.ParticleInterval := 0.001;
                                if v1AIShips[AInr].shipType = 'Nelson' then
                                begin
                                v1AIShips[AInr].GunBRT := 1510;
                                end
                                else
                                begin
                                v1AIShips[AInr].GunBRT := 1210;
                                end;
                            selv1AIGunBFireEmit := glScene1.FindSceneObject(v1AIShips[AInr].name + 'GunBFireEmit');
                            selv1AIGunFireSpriteB := glScene1.FindSceneObject(v1AIShips[AInr].name + 'ExplSpriteB') as tglSprite;

                            selv1AIGunFireSpriteB.Material.LibMaterialName := '1';
                            selv1AIGunFireSpriteB.visible := true;
                            //selv1AIGunBFire := getOrCreateSourcePFX(selv1AIGunBFireEmit);
                            //selv1AIGunBFire.ParticleInterval := 0.0005;
                            v1AIShips[AInr].MainGunAmmo := v1AIShips[AInr].MainGunAmmo - v1AIShips[AInr].TurretBGunCount;

                            for tempIntZ := 0 to v1AIShips[AInr].TurretBGunCount - 1 do
                            begin
                            v1AIRound_type1 := TGLCone(AIGunRoundHolder.AddNewChild(TGLCone));

                            v1AIFlyingRoundsCounter := v1AIFlyingRoundsCounter + 1;
                            v1AIRound_type1.Name := selv1AI.Name + 'v1AIRound_typeI' + intToStr(v1AIFlyingRoundsCounter);
                            v1AIRound_type1.AbsolutePosition := selv1AIGunBFireEmit.AbsolutePosition;
                            v1AIRound_type1.AbsoluteDirection := selv1AIGunBFireEmit.AbsoluteDirection;
                            v1AIRound_type1.Material.FrontProperties.Emission.SetColor(1,0,0,1);
                            v1AIRound_type1.Up.Z := 1;
                            //v1AIRound_type1.Up.X := 0;
                            v1AIRound_type1.Up.Y := 0;

                                    //With GetOrCreateCollision(v1AIRound_type1) Do
                                    //begin
                                    //BoundingMode:=cbmCube;
                                    //Manager:=v1AIRoundCollMan;
                                    //end;

                            Selv1AIGunBAimBox := glScene1.FindSceneObject(v1AIShips[AInr].name + 'GunBAimBox');
                            //Selv1AIGunBNodes := glScene1.FindSceneObject(v1AIShips[AInr].name + 'GunB1Nodes');
                                case tempIntZ of
                                 0: Selv1AIGunBNodes := glScene1.FindSceneObject(v1AIShips[AInr].name + 'GunB1Nodes');
                                 1: Selv1AIGunBNodes := glScene1.FindSceneObject(v1AIShips[AInr].name + 'GunB2Nodes');
                                 2: Selv1AIGunBNodes := glScene1.FindSceneObject(v1AIShips[AInr].name + 'GunB3Nodes');
                                 end;
                            Selv1AIGunBNodes.Visible := EtrajCB.Checked;

                            Selv1AIGunBAimBox.Position.X := 0 + GLS_RNG.Random(4) - 2 + (GLS_RNG.Random(Selv1AIGunPlotAccuracy) - (Selv1AIGunPlotAccuracy / 2));
                            Selv1AIGunBAimBox.Position.Z := 0 + GLS_RNG.Random(4) - 2 + (GLS_RNG.Random(Selv1AIGunPlotAccuracy) - (Selv1AIGunPlotAccuracy / 2));

                            v1AI_type1path_dummy.AbsolutePosition := v1AIRound_type1.AbsolutePosition;
                            v1AI_type1path_dummy2.AbsolutePosition := Selv1AIGunBAimBox.AbsolutePosition;
                                    with Selv1AIGunBNodes as TGLLines do
                                    begin
                                    nodes.Clear;
                                    AddNode(v1AI_type1path_dummy.Position.X,v1AI_type1path_dummy.Position.y,v1AI_type1path_dummy.Position.z);
                                    SplineMode := lsmCubicSpline;
                                    end;

                            tempVector := v1AI_type1path_dummy.AbsolutePosition;

                            v1AIRound_type1_Move := GetOrCreateMovement(v1AIRound_type1);
                            v1AIRound_type1_Move.ClearPaths;
                            v1AIRound_type1_Path := v1AIRound_type1_Move.AddPath;
                            v1AIRound_type1_Path.Name := v1AIRound_type1.name + 'Path';
                            v1AIRound_type1_Path.Nodes.Clear;
                            v1AIRound_type1_Node := v1AIRound_type1_Path.AddNode;

                            v1AIRound_type1_Node.PositionAsVector := tempVector;
                            v1AIRound_type1_Node.Speed := (4000);

                            tempSingX := (v1AI_type1path_dummy2.Position.X + v1AI_type1path_dummy.Position.X) * 0.50;
                            tempSingY := (v1AI_type1path_dummy2.Position.Y + v1AI_type1path_dummy.Position.Y) * 0.50;
                            tempSingZ := (v1AI_type1path_dummy2.Position.Z + v1AI_type1path_dummy.Position.Z) * 0.50;

                            with Selv1AIGunBNodes as TGLLines do
                            begin
                            AddNode(tempSingX,tempSingy + (selv1AIGunBFireEmit.distanceTo(Selv1AIGunBAimBox)/100),tempSingz);
                            end;

                            v1AIRound_type1_Node := v1AIRound_type1_Path.AddNode;
                            v1AIRound_type1_Node.X := tempSingX;
                            v1AIRound_type1_Node.Y := tempSingy + (selv1AIGunBFireEmit.distanceTo(Selv1AIGunBAimBox)/100);
                            v1AIRound_type1_Node.Z := tempSingz;
                            //v1AIRound_type1_Node.PositionAsVector := Selv1AIGunBAimBox.AbsolutePosition;
                            v1AIRound_type1_Node.Speed := (4000);

                            v1AIRound_type1_Node := v1AIRound_type1_Path.AddNode;
                            v1AIRound_type1_Node.X := v1AI_type1path_dummy2.Position.X;
                            v1AIRound_type1_Node.Y := 0; //v1AI_type1path_dummy2.Position.Y;
                            v1AIRound_type1_Node.Z := v1AI_type1path_dummy2.Position.Z;
                            v1AIRound_type1_Node.Speed := (4000);

                                    with Selv1AIGunBNodes as TGLLines do
                                    begin
                                    AddNode(v1AI_type1path_dummy2.Position.X,0 ,v1AI_type1path_dummy2.Position.z);
                                    end;

                            v1AIRound_type1_Move.ActivePath := v1AIRound_type1_Path;
                            v1AIRound_type1_Move.ActivePathIndex := 0;

                                    if Assigned(v1AIRound_type1_Move) then
                                    v1AIRound_type1_Move.StartPathTravel;
                            v1AIRound_type1_Move.OnPathTravelStop := v1AIRoundPathTravelStop;
                            end;

                            //mySFX := OALManager.Add('Sounds/EnemyFire1.wav');
                            mySFX.Volume.value := 1000 - 999 * (cameraCube.DistanceTo(selv1AIGunBSmokeEmit) / 100000);
                            mySFX := OALManager.GetSoundByIndex(mySFXEnemyFireIndex + mySFXEnemyFireCount);
                            mySFX.Pitch.Value := 1 + (((GLS_RNG.Random(10)) - 5) * 0.1);
                            mySFX.play;

                                     if mySFXEnemyFireCount >= mySFXEnemyFireMax - 1 then
                                     begin
                                     mySFXEnemyFireCount := 0;
                                     end
                                     else
                                     begin
                                     mySFXEnemyFireCount := mySFXEnemyFireCount + 1;
                                     end;

                            //Selv1AIGunBSoundFX := getOrCreateSoundEmitter(selv1AIGunBSmokeEmit);
                            //Selv1AIGunBSoundFX.Source.SoundLibrary:=SoundLib1;
                            //Selv1AIGunBSoundFX.Source.SoundName:='EnemyFire1SFX';
                            //Selv1AIGunBSoundFX.source.MaxDistance := 100;
                            //Selv1AIGunBSoundFX.source.ConeOutsideVolume := 0.5;
                            //Selv1AIGunBSoundFX.Playing:=True;

                            end;
                    end;

                    if selv1AIGunC.TurnAngle = v1AIShips[AInr].GunCdir * -1 then
                    begin
                            if (v1AIShips[AInr].GunCRT <= 0) and (v1AIShips[AInr].MainGunAmmo > v1AIShips[AInr].TurretCGunCount - 1) and (GunCReady = True) then
                            begin
                                 if TCTB.Position > 1 then
                                 tctb.Position := 1;
                            selv1AIGunCSmokeEmit := glScene1.FindSceneObject(v1AIShips[AInr].name + 'GunCSmokeEmit');
                            selv1AIGunCSmoke := getOrCreateSourcePFX(selv1AIGunCSmokeEmit);
                            selv1AIGunCSmoke.ParticleInterval := 0.001;
                                if v1AIShips[AInr].shipType = 'Nelson' then
                                begin
                                v1AIShips[AInr].GunCRT := 1470;
                                end
                                else
                                begin
                                v1AIShips[AInr].GunCRT := 1190;
                                end;
                            selv1AIGunCFireEmit := glScene1.FindSceneObject(v1AIShips[AInr].name + 'GunCFireEmit');
                            selv1AIGunFireSpriteC := glScene1.FindSceneObject(v1AIShips[AInr].name + 'ExplSpriteC') as tglSprite;
                            selv1AIGunFireSpriteC.Material.LibMaterialName := '1';
                            selv1AIGunFireSpriteC.visible := true;
                            //selv1AIGunCFire := getOrCreateSourcePFX(selv1AIGunCFireEmit);
                            //selv1AIGunCFire.ParticleInterval := 0.0005;
                            v1AIShips[AInr].MainGunAmmo := v1AIShips[AInr].MainGunAmmo - v1AIShips[AInr].TurretCGunCount;

                            for tempIntZ := 0 to v1AIShips[AInr].TurretCGunCount - 1 do
                            begin
                            v1AIRound_type1 := TGLCone(AIGunRoundHolder.AddNewChild(TGLCone));

                            v1AIFlyingRoundsCounter := v1AIFlyingRoundsCounter + 1;
                            v1AIRound_type1.Name := selv1AI.Name + 'v1AIRound_typeI' + intToStr(v1AIFlyingRoundsCounter);
                            v1AIRound_type1.AbsolutePosition := selv1AIGunCFireEmit.AbsolutePosition;
                            v1AIRound_type1.AbsoluteDirection := selv1AIGunCFireEmit.AbsoluteDirection;
                            v1AIRound_type1.Material.FrontProperties.Emission.SetColor(1,0,0,1);
                            v1AIRound_type1.Up.Z := 1;
                            //v1AIRound_type1.Up.X := 0;
                            v1AIRound_type1.Up.Y := 0;

                                    //With GetOrCreateCollision(v1AIRound_type1) Do
                                    //begin
                                    //BoundingMode:=cbmCube;
                                    //Manager:=v1AIRoundCollMan;
                                    //end;

                            Selv1AIGunCAimBox := glScene1.FindSceneObject(v1AIShips[AInr].name + 'GunCAimBox');
                            //Selv1AIGunCNodes := glScene1.FindSceneObject(v1AIShips[AInr].name + 'GunC1Nodes');
                                case tempIntZ of
                                 0: Selv1AIGunCNodes := glScene1.FindSceneObject(v1AIShips[AInr].name + 'GunC1Nodes');
                                 1: Selv1AIGunCNodes := glScene1.FindSceneObject(v1AIShips[AInr].name + 'GunC2Nodes');
                                 2: Selv1AIGunCNodes := glScene1.FindSceneObject(v1AIShips[AInr].name + 'GunC3Nodes');
                                 end;
                            Selv1AIGunCNodes.Visible := EtrajCB.Checked;

                            Selv1AIGunCAimBox.Position.X := 0 + GLS_RNG.Random(4) - 2 + (GLS_RNG.Random(Selv1AIGunPlotAccuracy) - (Selv1AIGunPlotAccuracy / 2));
                            Selv1AIGunCAimBox.Position.Z := 0 + GLS_RNG.Random(4) - 2 + (GLS_RNG.Random(Selv1AIGunPlotAccuracy) - (Selv1AIGunPlotAccuracy / 2));

                            v1AI_type1path_dummy.AbsolutePosition := v1AIRound_type1.AbsolutePosition;
                            v1AI_type1path_dummy2.AbsolutePosition := Selv1AIGunCAimBox.AbsolutePosition;
                                    with Selv1AIGunCNodes as TGLLines do
                                    begin
                                    nodes.Clear;
                                    AddNode(v1AI_type1path_dummy.Position.X,v1AI_type1path_dummy.Position.y,v1AI_type1path_dummy.Position.z);
                                    SplineMode := lsmCubicSpline;
                                    end;

                            tempVector := v1AI_type1path_dummy.AbsolutePosition;

                            v1AIRound_type1_Move := GetOrCreateMovement(v1AIRound_type1);
                            v1AIRound_type1_Move.ClearPaths;
                            v1AIRound_type1_Path := v1AIRound_type1_Move.AddPath;
                            v1AIRound_type1_Path.Name := v1AIRound_type1.name + 'Path';
                            v1AIRound_type1_Path.Nodes.Clear;
                            v1AIRound_type1_Node := v1AIRound_type1_Path.AddNode;

                            v1AIRound_type1_Node.PositionAsVector := tempVector;
                            v1AIRound_type1_Node.Speed := (4000);

                            tempSingX := (v1AI_type1path_dummy2.Position.X + v1AI_type1path_dummy.Position.X) * 0.50;
                            tempSingY := (v1AI_type1path_dummy2.Position.Y + v1AI_type1path_dummy.Position.Y) * 0.50;
                            tempSingZ := (v1AI_type1path_dummy2.Position.Z + v1AI_type1path_dummy.Position.Z) * 0.50;

                            with Selv1AIGunCNodes as TGLLines do
                            begin
                            AddNode(tempSingX,tempSingy + (selv1AIGunCFireEmit.distanceTo(Selv1AIGunCAimBox)/100),tempSingz);
                            end;

                            v1AIRound_type1_Node := v1AIRound_type1_Path.AddNode;
                            v1AIRound_type1_Node.X := tempSingX;
                            v1AIRound_type1_Node.Y := tempSingy + (selv1AIGunCFireEmit.distanceTo(Selv1AIGunCAimBox)/100);
                            v1AIRound_type1_Node.Z := tempSingz;
                            //v1AIRound_type1_Node.PositionAsVector := Selv1AIGunCAimBox.AbsolutePosition;
                            v1AIRound_type1_Node.Speed := (4000);

                            v1AIRound_type1_Node := v1AIRound_type1_Path.AddNode;
                            v1AIRound_type1_Node.X := v1AI_type1path_dummy2.Position.X;
                            v1AIRound_type1_Node.Y := 0; //v1AI_type1path_dummy2.Position.Y;
                            v1AIRound_type1_Node.Z := v1AI_type1path_dummy2.Position.Z;
                            v1AIRound_type1_Node.Speed := (4000);

                                    with Selv1AIGunCNodes as TGLLines do
                                    begin
                                    AddNode(v1AI_type1path_dummy2.Position.X,0 ,v1AI_type1path_dummy2.Position.z);
                                    end;


                            v1AIRound_type1_Move.ActivePath := v1AIRound_type1_Path;
                            v1AIRound_type1_Move.ActivePathIndex := 0;

                                    if Assigned(v1AIRound_type1_Move) then
                                    v1AIRound_type1_Move.StartPathTravel;
                            v1AIRound_type1_Move.OnPathTravelStop := v1AIRoundPathTravelStop;
                            end;

                            //mySFX := OALManager.Add('Sounds/EnemyFire1.wav');
                            mySFX.Volume.value := 1000 - 999 * (cameraCube.DistanceTo(selv1AIGunCSmokeEmit) / 100000);
                            mySFX := OALManager.GetSoundByIndex(mySFXEnemyFireIndex + mySFXEnemyFireCount);
                            mySFX.Pitch.Value := 1 + (((GLS_RNG.Random(10)) - 5) * 0.1);
                            mySFX.play;

                                     if mySFXEnemyFireCount >= mySFXEnemyFireMax - 1 then
                                     begin
                                     mySFXEnemyFireCount := 0;
                                     end
                                     else
                                     begin
                                     mySFXEnemyFireCount := mySFXEnemyFireCount + 1;
                                     end;

                                //Selv1AIGunCSoundFX := getOrCreateSoundEmitter(selv1AIGunCSmokeEmit);
                                //Selv1AIGunCSoundFX.Source.SoundLibrary:=SoundLib1;
                                //Selv1AIGunCSoundFX.Source.SoundName:='EnemyFire1SFX';
                                //Selv1AIGunCSoundFX.source.MaxDistance := 100;
                                //Selv1AIGunCSoundFX.source.ConeOutsideVolume := 0.5;
                                //Selv1AIGunCSoundFX.Playing:=True;


                            end;
                    end;

                    if v1AIShips[AInr].guns > 3 then
                    begin
                        if selv1AIGunD.TurnAngle = v1AIShips[AInr].GunDdir * -1 then
                        begin
                                if (v1AIShips[AInr].GunDRT <= 0) and (v1AIShips[AInr].MainGunAmmo > v1AIShips[AInr].TurretDGunCount - 1) and (GunDReady = True) then
                                begin
                                  if TCTB.Position > 1 then
                                  tctb.Position := 1;
                                selv1AIGunDSmokeEmit := glScene1.FindSceneObject(v1AIShips[AInr].name + 'GunDSmokeEmit');
                                selv1AIGunDSmoke := getOrCreateSourcePFX(selv1AIGunDSmokeEmit);
                                selv1AIGunDSmoke.ParticleInterval := 0.001;
                                v1AIShips[AInr].GunDRT := 1150;
                                selv1AIGunDFireEmit := glScene1.FindSceneObject(v1AIShips[AInr].name + 'GunDFireEmit');
                                selv1AIGunFireSpriteD := glScene1.FindSceneObject(v1AIShips[AInr].name + 'ExplSpriteD') as tglSprite;
                                selv1AIGunFireSpriteD.Material.LibMaterialName := '1';
                                selv1AIGunFireSpriteD.visible := true;
                                //selv1AIGunDFire := getOrCreateSourcePFX(selv1AIGunDFireEmit);
                                //selv1AIGunDFire.ParticleInterval := 0.0005;
                                v1AIShips[AInr].MainGunAmmo := v1AIShips[AInr].MainGunAmmo - v1AIShips[AInr].TurretDGunCount;

                                for tempIntZ := 0 to v1AIShips[AInr].TurretDGunCount - 1 do
                                begin
                                v1AIRound_type1 := TGLCone(AIGunRoundHolder.AddNewChild(TGLCone));

                                v1AIFlyingRoundsCounter := v1AIFlyingRoundsCounter + 1;
                                v1AIRound_type1.Name := selv1AI.Name + 'v1AIRound_typeI' + intToStr(v1AIFlyingRoundsCounter);
                                v1AIRound_type1.AbsolutePosition := selv1AIGunDFireEmit.AbsolutePosition;
                                v1AIRound_type1.AbsoluteDirection := selv1AIGunDFireEmit.AbsoluteDirection;
                                v1AIRound_type1.Material.FrontProperties.Emission.SetColor(1,0,0,1);
                                v1AIRound_type1.Up.Z := 1;
                                //v1AIRound_type1.Up.X := 0;
                                v1AIRound_type1.Up.Y := 0;

                                        //With GetOrCreateCollision(v1AIRound_type1) Do
                                        //begin
                                        //BoundingMode:=cbmCube;
                                        //Manager:=v1AIRoundCollMan;
                                        //end;

                                Selv1AIGunDAimBox := glScene1.FindSceneObject(v1AIShips[AInr].name + 'GunDAimBox');
                                //Selv1AIGunDNodes := glScene1.FindSceneObject(v1AIShips[AInr].name + 'GunDNodes');
                                    case tempIntZ of
                                     0: Selv1AIGunDNodes := glScene1.FindSceneObject(v1AIShips[AInr].name + 'GunD1Nodes');
                                     1: Selv1AIGunDNodes := glScene1.FindSceneObject(v1AIShips[AInr].name + 'GunD2Nodes');
                                     2: Selv1AIGunDNodes := glScene1.FindSceneObject(v1AIShips[AInr].name + 'GunD3Nodes');
                                     end;
                                Selv1AIGunDNodes.Visible := EtrajCB.Checked;

                                Selv1AIGunDAimBox.Position.X := 0 + GLS_RNG.Random(4) - 2 + (GLS_RNG.Random(Selv1AIGunPlotAccuracy) - (Selv1AIGunPlotAccuracy / 2));
                                Selv1AIGunDAimBox.Position.Z := 0 + GLS_RNG.Random(4) - 2 + (GLS_RNG.Random(Selv1AIGunPlotAccuracy) - (Selv1AIGunPlotAccuracy / 2));

                                v1AI_type1path_dummy.AbsolutePosition := v1AIRound_type1.AbsolutePosition;
                                v1AI_type1path_dummy2.AbsolutePosition := Selv1AIGunDAimBox.AbsolutePosition;
                                        with Selv1AIGunDNodes as TGLLines do
                                        begin
                                        nodes.Clear;
                                        AddNode(v1AI_type1path_dummy.Position.X,v1AI_type1path_dummy.Position.y,v1AI_type1path_dummy.Position.z);
                                        SplineMode := lsmCubicSpline;
                                        end;

                                tempVector := v1AI_type1path_dummy.AbsolutePosition;

                                v1AIRound_type1_Move := GetOrCreateMovement(v1AIRound_type1);
                                v1AIRound_type1_Move.ClearPaths;
                                v1AIRound_type1_Path := v1AIRound_type1_Move.AddPath;
                                v1AIRound_type1_Path.Name := v1AIRound_type1.name + 'Path';
                                v1AIRound_type1_Path.Nodes.Clear;
                                v1AIRound_type1_Node := v1AIRound_type1_Path.AddNode;

                                v1AIRound_type1_Node.PositionAsVector := tempVector;
                                v1AIRound_type1_Node.Speed := (4000);

                                tempSingX := (v1AI_type1path_dummy2.Position.X + v1AI_type1path_dummy.Position.X) * 0.50;
                                tempSingY := (v1AI_type1path_dummy2.Position.Y + v1AI_type1path_dummy.Position.Y) * 0.50;
                                tempSingZ := (v1AI_type1path_dummy2.Position.Z + v1AI_type1path_dummy.Position.Z) * 0.50;

                                with Selv1AIGunDNodes as TGLLines do
                                begin
                                AddNode(tempSingX,tempSingy + (selv1AIGunDFireEmit.distanceTo(Selv1AIGunDAimBox)/100),tempSingz);
                                end;

                                v1AIRound_type1_Node := v1AIRound_type1_Path.AddNode;
                                v1AIRound_type1_Node.X := tempSingX;
                                v1AIRound_type1_Node.Y := tempSingy + (selv1AIGunDFireEmit.distanceTo(Selv1AIGunDAimBox)/100);
                                v1AIRound_type1_Node.Z := tempSingz;
                                //v1AIRound_type1_Node.PositionAsVector := Selv1AIGunDAimBox.AbsolutePosition;
                                v1AIRound_type1_Node.Speed := (4000);

                                v1AIRound_type1_Node := v1AIRound_type1_Path.AddNode;
                                v1AIRound_type1_Node.X := v1AI_type1path_dummy2.Position.X;
                                v1AIRound_type1_Node.Y := 0; //v1AI_type1path_dummy2.Position.Y;
                                v1AIRound_type1_Node.Z := v1AI_type1path_dummy2.Position.Z;
                                v1AIRound_type1_Node.Speed := (4000);

                                        with Selv1AIGunDNodes as TGLLines do
                                        begin
                                        AddNode(v1AI_type1path_dummy2.Position.X,0,v1AI_type1path_dummy2.Position.z);
                                        end;

                                v1AIRound_type1_Move.ActivePath := v1AIRound_type1_Path;
                                v1AIRound_type1_Move.ActivePathIndex := 0;

                                        if Assigned(v1AIRound_type1_Move) then
                                        v1AIRound_type1_Move.StartPathTravel;
                                v1AIRound_type1_Move.OnPathTravelStop := v1AIRoundPathTravelStop;
                                end;

                                //mySFX := OALManager.Add('Sounds/EnemyFire1.wav');
                                mySFX.Volume.value := 1000 - 999 * (cameraCube.DistanceTo(selv1AIGunDSmokeEmit) / 100000);
                                mySFX := OALManager.GetSoundByIndex(mySFXEnemyFireIndex + mySFXEnemyFireCount);
                                mySFX.Pitch.Value := 1 + (((GLS_RNG.Random(10)) - 5) * 0.1);
                                mySFX.play;

                                     if mySFXEnemyFireCount >= mySFXEnemyFireMax - 1 then
                                     begin
                                     mySFXEnemyFireCount := 0;
                                     end
                                     else
                                     begin
                                     mySFXEnemyFireCount := mySFXEnemyFireCount + 1;
                                     end;

                                //Selv1AIGunDSoundFX := getOrCreateSoundEmitter(selv1AIGunDSmokeEmit);
                                //Selv1AIGunDSoundFX.Source.SoundLibrary:=SoundLib1;
                                //Selv1AIGunDSoundFX.Source.SoundName:='EnemyFire1SFX';
                                //Selv1AIGunDSoundFX.source.MaxDistance := 100;
                                //Selv1AIGunDSoundFX.source.ConeOutsideVolume := 0.5;
                                //Selv1AIGunDSoundFX.Playing:=True;

                                end;
                        end;
                    end;
            end;

            if (v1AIShips[AInr].HasTarget = true) and (v1AIShips[AInr].SolutionTimer >= 1) then
            begin
            v1AIShips[AInr].SolutionTimer := v1AIShips[AInr].SolutionTimer - (deltaTime * TC);
            end;

            If v1AIShips[AInr].GunART > 0 then
            v1AIShips[AInr].GunART := v1AIShips[AInr].GunART - (1 * deltaTime * 60 * tc);
            If v1AIShips[AInr].GunBRT > 0 then
            v1AIShips[AInr].GunBRT := v1AIShips[AInr].GunBRT - (1 * deltaTime * 60 * tc);
            If v1AIShips[AInr].GunCRT > 0 then
            v1AIShips[AInr].GunCRT := v1AIShips[AInr].GunCRT - (1 * deltaTime * 60 * tc);


                selv1AIGunA.TurnAngle := v1AIShips[AInr].GunAdir * -1;
                selv1AIGunB.TurnAngle := v1AIShips[AInr].GunBdir * -1;
                selv1AIGunC.TurnAngle := v1AIShips[AInr].GunCdir * -1;
              if v1AIShips[AInr].guns > 3 then
              begin
                  If v1AIShips[AInr].GunDRT > 0 then
                  v1AIShips[AInr].GunDRT := v1AIShips[AInr].GunDRT - (1 * deltaTime * 60 * tc);
              selv1AIGunD.TurnAngle := v1AIShips[AInr].GunDdir * -1;
              end;
            end;
        end;
    end;



     For tempIntX := 0 To v1AILandedRoundsList.Count - 1 Do
     begin
          if AIGunRoundHolder.FindChild(v1AILandedRoundsList[tempIntX],true).Visible = true then
          begin
           selv1AICreateSplashEmit := tglDummyCube.CreateAsChild(v1AISplashHolder);


           v1SplashCounter := v1SplashCounter + 1;
           selv1AICreateSplashEmit.Name := v1AILandedRoundsList[tempIntX] + 'Splash' + intToStr(v1SplashCounter);
           selv1AISplashList.Append(selv1AICreateSplashEmit.Name + '=3');
           selv1AICreateSplashEmit.AbsolutePosition := AIGunRoundHolder.FindChild(v1AILandedRoundsList[tempIntX],true).AbsolutePosition;
           selv1AICreateSplashEmit.Position.Y := 0;
           Selv1AICreateSplash := getOrCreateSourcePFX(selv1AICreateSplashEmit);
           //Selv1AICreateSplash.Manager := MyGrafSpeeSplashFXMan;
           Selv1AICreateSplash.Manager := bowWakeManager;
           Selv1AICreateSplash.EffectScale := 3;
           Selv1AICreateSplash.InitialVelocity.Y := 10 + GLS_RNG.Random(10);
           Selv1AICreateSplash.ParticleInterval := 0.01;
           Selv1AICreateSplash.VelocityDispersion := 2 + GLS_RNG.Random(10);
           Selv1AICreateSplash.PositionDispersion := 0.5;
           Selv1AICreateSplash.RotationDispersion := 8;
           Selv1AICreateSplash.DispersionMode := sdmIsotropic;

           //mySFX := OALManager.Add('Sounds/WaterSplash1.wav');
           mySFX12.Volume.value := 1000 - 999 * (cameraCube.DistanceTo(selv1AICreateSplashEmit) / 20000);
           mySFX12 := OALManager.GetSoundByIndex(mySFXSplashIndex + mySFXSplashCount);
           mySFX12.Pitch.Value := 1 + (((GLS_RNG.Random(10)) - 5) * 0.1);
           mySFX12.play;

           if mySFXSplashCount >= mySFXSplashMax - 1 then
           begin
           mySFXSplashCount := 0;
           end
           else
           begin
           mySFXSplashCount := mySFXSplashCount + 1;
           end;

           //newSplashProxy := TGLPlane.Create(FBOWakeProxies);
           newSplashProxy := TGLProxyObject.Create(FBOWakeProxies);
           newSplashProxy.Parent := FBOSplashProxies;
           newSplashProxy.MasterObject := wakeTexMaster;
           newSplashProxy.AbsolutePosition := selv1AICreateSplashEmit.AbsolutePosition;
           newSplashProxy.turnAngle := GLS_RNG.Random(360);
           newSplashProxy.PitchAngle:= 90;
           newSplashProxy.ProxyOptions:= [pooObjects];
           newSplashProxy.Scale.X := 0.25;
           newSplashProxy.Scale.y := 0.25;
           newSplashProxy.Pickable:= false;
           //newSplashProxy.Material.MaterialLibrary := BCOceanMatLib;
           //newSplashProxy.Material.LibMaterialName := 'foamTex2';
           //newSplashProxy.Material.Texture.Image := BCOceanMatLib.Materials[6].Material.Texture.image;
           //newSplashProxy.Material.texture := BCOceanMatLib.Materials[6].Material.texture;
           //newSplashProxy.Material.texture.Disabled := false;
           //newSplashProxy.Width := 48;
           //newSplashProxy.Height := 48;

           AIGunRoundHolder.FindChild(v1AILandedRoundsList[tempIntX],true).Free;
           //MyGrafSpeeGunPathHolder.FindChild(v1AILandedRoundsList[tempIntX] + 'Line',true).Free;
           end
          else
          begin
          AIGunRoundHolder.FindChild(v1AILandedRoundsList[tempIntX],true).Free;
          end;
     end;

     v1AILandedRoundsList.clear;

     if v1AISplashHolder.Count > 0 then
     begin

        For tempIntX := 0 To selv1AISplashList.Count - 1 Do
        begin
        selv1AISplashList.Values[selv1AISplashList.Names[tempIntX]] := floatToStr(strToFloat(selv1AISplashList.Values[selv1AISplashList.Names[tempIntX]]) - (2 * deltaTime));

                if strToFloat(selv1AISplashList.Values[selv1AISplashList.Names[tempIntX]]) <= 0 then
                begin
                v1AISplashHolder.FindChild(selv1AISplashList.Names[tempIntX], true).Free;
                end;
        end;

        for tempIntY := 0 to v1AISplashHolder.Count - 1 do
        begin
        selv1AICreateSplashEmit := v1AISplashHolder.Children[tempIntY] as tglDummyCube;
        Selv1AICreateSplash := getOrCreateSourcePFX(selv1AICreateSplashEmit);
        Selv1AICreateSplash.InitialVelocity.y := Selv1AICreateSplash.InitialVelocity.y - (GLS_RNG.Random(100) * 0.01);
        end;

     end;

     if selv1AISplashList.Count > 31 then
     begin
     selv1AISplashList.Delete(0);
     selv1AIGrabSplashEmit := glScene1.FindSceneObject(selv1AISplashList.Names[0]);
     selv1AIGrabSplashEmit.Free;
     end;

     //despawn if out of view
     if Selv1AI.DistanceTo(myShip) > 40000 * 4 then
     begin
     DespawnUnit(AInr, v1AIShips[AInr].ID);
     end;
end; 
