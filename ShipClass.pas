unit AIMerchantShips;

{$MODE Delphi}

interface
type

        TAIMerchantShip = class

        private


        public
                name: string;

                CMGroupNr: integer;
                CMShipNr: integer;
                ID: integer;
                CMID: integer;
                shipType: string;
                faction: integer; //0 = german, 1 = allied
                scale: integer;
                EXP: integer;
                health: Integer;
                Fuel: Single;
                Heading: Single;
                PositionX: Single;
                PositionY: Single;
                NewPositionX: Single;
                NewPositionY: Single;
                pitch: single;
                pitchRate: single;
                roll: single;
                rollRate: single;
                draftY: single;
                storedY: single; //For horizon tests...
                RandomPos: boolean;
                RandomWP: boolean;
                speed, wantedSpeed: single;
                topSpeed: integer;
                mode: integer; //0 = cruise, 1 = avoid, 2 = attack, 3 = convoj
                convojInfo: array[0..3] of integer; //convojLeader AInr - pos in convoj - angle - dist from leader
                MissionObjective: integer; //0=No, 1=Destroy, 2=protect
                enabled: boolean;
                DistanceToTarget: single;
                path: integer;
                currentWaypoint: integer;
                waypoints: array[0..99, 0..2] of integer; //0=X, 1=Y, 2=WantedSpeed, [0,0] = nr of waypoints

                stacks: integer;

                hitSpots: array[0..16, 0..2] of single; //spots with xyz positions

                //stuff for player
                isSpotted: boolean;
                spotableDistance: integer;

                //For warships
                guns: integer;
                MainCaliber: integer; //set to 1 on unarmed ships
                DetectionRange: single;
                MainGunAmmo: integer;
                MaxFireRange: single;
                GunAdir, GunBdir, GunCdir, GunDdir: single;
                GunART, GunBRT, GunCRT, GunDRT: single;
                TurretAGunCount, TurretBGunCount, TurretCGunCount, TurretDGunCount: integer;
                HasTarget: boolean;
                IsTargetPlayer: boolean;
                TargetID: integer;
                TargetObject: string;
                SolutionTimer: single;
        constructor create;
        end;

implementation
constructor TAIMerchantShip.create;
begin

end;

end.
