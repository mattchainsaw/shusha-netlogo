breed [ infantrys infantry ]
breed [ artillerys artillery ]
breed [ drones drone ]

globals [
  aze_color
  arm_color
  flat_color
  forest_color
  river_color
  mountain_color
  sim_map_56

  ;; Report Values
  AZE_infantry_kills
  ARM_infantry_kills
  AZE_artillery_kills
  ARM_artillery_kills
  AZE_drone_spots
  ARM_drone_spots

  ;; Agent Counts
  arm_infantry_count
  aze_infantry_count
  arm_artillery_count
  aze_artillery_count
  arm_drone_count
  aze_drone_count

  ;; Agent Stats - Set in Interface
  ;infantry_init_health
  ;infantry_speed
  ;infantry_hit_rate
  ;infantry_hit_accuracy
  ;infantry_hit_distance
  ;artillery_init_health
  ;artillery_hit_rate
  ;artillery_hit_accuracy
  ;artillery_hit_distance
  ;drone_speed
  ;drone_view_rate
  ;drone_view_accuracy
  ;drone_view_distance
  ;fog_coverage
]

infantrys-own [
  side     ;; Who does this agent fight for?
  kind     ;; What type of agent is it?
  health   ;; Health Points
  speed    ;; Speed
  rate     ;; How fast can weapon be used?
  accuracy ;; How likely to hit or view
  dist     ;; How far away can the agent hit or view
  in-city? ;; boolean of if in the city
]

artillerys-own [
  side     ;; Who does this agent fight for?
  kind     ;; What type of agent is it?
  health   ;; Health Points
  speed    ;; Speed
  rate     ;; How fast can weapon be used?
  accuracy ;; How likely to hit or view
  dist     ;; How far away can the agent hit or view
  targets  ;; List of targets
]

drones-own [
  side     ;; Who does this agent fight for?
  kind     ;; What type of agent is it?
  health   ;; Health Points
  speed    ;; Speed
  rate     ;; How fast can weapon be used?
  accuracy ;; How likely to hit or view
  dist     ;; How far away can the agent hit or view
]

patches-own [
  patch_pos           ;; Patch Position
  environment         ;; What type of patch is it?
  mod_infantry_speed  ;; Infantry Speed modifier by env
  mod_infantry_acc    ;; Infantry Accuracy modifier by env
  mod_artillery_acc   ;; Artillery Accuracy modifier by env
  mod_artillery_acc_d ;; Artillery Drone Assist Accuracy modifier by env
  mod_drone_acc       ;; Drone View Accuracy modifier by env
  fog_density         ;; Density of fog
  old_density         ;; Fog Movement Helper
  covering_count
]

to set_globals
  set aze_color 93
  set arm_color 13
  set flat_color 36
  set forest_color 56
  set river_color blue
  set mountain_color 6
  set AZE_infantry_kills 0
  set ARM_infantry_kills 0
  set AZE_artillery_kills 0
  set ARM_artillery_kills 0
  set AZE_drone_spots 0
  set ARM_drone_spots 0

  if troop_count_scenario = "Equal" [
    set arm_infantry_count 100
    set aze_infantry_count 100
    set arm_artillery_count 10
    set aze_artillery_count 70
    set arm_drone_count 1
    set aze_drone_count 3
  ]
  if troop_count_scenario = "AZE_Reported" [
    set arm_infantry_count 100
    set aze_infantry_count 20
    set arm_artillery_count 10
    set aze_artillery_count 70
    set arm_drone_count 1
    set aze_drone_count 3
  ]
  if troop_count_scenario = "ARM_Reported" [
    set arm_infantry_count 100
    set aze_infantry_count 300
    set arm_artillery_count 10
    set aze_artillery_count 70
    set arm_drone_count 1
    set aze_drone_count 3
  ]

  ;; Map for 56x56
  set sim_map_56 (word
    "MMMMMMMMMMMMFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFGGGGGGGGGG"
    "MMMMMMMMMMMFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFGGGGGGGGGGG"
    "MMMMMMMMMMFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFGGGGGGGGGGG"
    "MMMMMMMMFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFGGGGGGGGGGGG"
    "MMMMMMMFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFGGGGGGGGGGGG"
    "MMMMMMFFFFFFFFFFFFFFFFFFFFMMMMMMFFFFFFFFFFFGGGGGGGGGGGGG"
    "MMMMFFFFFFFFFFFFFFFFFFFFMMMMMMMMMMFFFFFFFFGGGGGGGGGGGGGF"
    "FFFFFFFFFFFFFFFFFFMMMMMMMMMMMMMMMMMMMFFFFGGGGGGGGGGGGGFF"
    "FFFFFFFFFFFFFFFFMMMMMMMMMMMMMMMMMMMMMMMMFGGGGGGGGGGGGFFF"
    "FFFFFFFFFFFFFFFMMMMMMMMMMMMMMMMMMMMMMMMMGGGGGGGGGGGGFFFF"
    "FFFFFFFFFFFFFFMMMMMMMMMMMMMMMMMMMMMMMMMMGGGGGGGGGGGFFFFF"
    "FFFFFFFFFFFFFMMMMMMMMMMMMMMMMMMMMMMMMMMMGGGGGGGGGGFFFFFF"
    "FFFFFFFFFFFFMMMMMMMMMMMMMMMMMMMMMMMMMMMMGGGGGGGGGGFFFFFF"
    "FFFFFFFFFFFFMMMMMMMMMFFFFFFFFFFFFFFFMMMMMGGGGGGGGGFFFFFF"
    "FFFFFFFFFFFMMMMMMMMMFFFFFFFFFFFFFFFFFMMMMGGGGGGGGGFFFFFF"
    "FFFFFFFFFFMMMMMMMMMFFFFFFFFFFFFFFFFFFFMMMMGGGGGGGGFFFFFF"
    "FFFFFFFFFFMMMMMMMMFFFFFFFFFFFFFFFFFFFFMMMMGGGGGGGGFFFFFF"
    "FFFFFFFFFMMMMMMMFFFFFFFFFFFFFFFFFFFFFFFMMMMGGGGGGGFFFFFF"
    "FFFFFFFFMMMMMMMMFFFFFFFFFFFFFFFFFFFFFFFFMMMMGGGGGGFFFFFF"
    "FFFFFFFFMMMMMMFFFFFFFFFFFFFFFFFFFFFFFFFFFMMMGGGGGGGFFFFF"
    "FFFFFFFMMMMMMFFFFFFFFFFFFFFFFFFFFFFFFFFFFMMMMGGGGGGFFFFF"
    "FFFFFFMMMMMMFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFMMMGGGGGGFFFFF"
    "GGGGGGMMMMMMFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFMMMMGGGGGGFFFF"
    "GGGGGGMMMMMFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFMMMMGGGGGGFFF"
    "GGGGGGGMMMMFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFMMMGGGGGGGFF"
    "GGGGGGGMMMMFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFMMMGGGGGGGFF"
    "GGGGGGGMMMMFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFMMMGGGGGGGGF"
    "GGGGGGGMMMMFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFMMMGGGGGGGGG"
    "GGGGGGGGMMMFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFMMMGGGGGGGGG"
    "GGGGGGGGMMMFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFMMMGGGGGGGGG"
    "GGGGGGGGMMMFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFMMMGGGGGGGGG"
    "GGGGGGGGMMMFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFMMMGGGGGGGGG"
    "GGGGGGGGMMMMFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFMMMGGGGGGGGG"
    "GGGGGGGGMMMMFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFMMMGGGGGGGGG"
    "GGGGGGGGGMMMFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFMMMGGGGGGGGG"
    "GGGGGGGGGMMMMFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFMMMGGGGGGGGG"
    "GGGGGGGGGGMMMFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFMMMMGGGGGGGG"
    "GGGGGGGGGGMMMMFFFFFFFFFFFFFFFFFFFFFFFFFFFFFMMMMMMMGGGGGG"
    "GGGGGGGGGGGMMMFFFFFFFFFFFFFFFFFFFFFFFFFFFFMMMMMMMMMGGGGG"
    "GGGGGGGGGGGMMMMFFFFFFFFFFFFFFFFFFFFFFFFFFMMMMMMMMMMMGGGG"
    "GGGGGGGGGGGGMMMFFFFFFFFFFFFFFFFFFFFFFFFFMMMMMMMMMMMMMGGG"
    "GGGGGGGGGGGGMMMMFFFFFFFFFFFFFFFFFFFFFFFMMMMMMMMMMMMMMMGG"
    "GGGGGGGGGGGGGMMMFFFFFFFFFFFFFFFFFFFFFFMMMMMMMMMMMMMMMMMM"
    "GGGGGGGGGGGGGMMMMFFFFFFFFFFFFFFFFFFFFMMMMMMMMMMMMMMMMMMM"
    "GGGGGGGGGGGGGGMMMFFFFFFFFFFFFFFFFFFFMMMMMMMMMMMMMMMMMMMM"
    "GGGGGGGGGGGGGGGMMMFFFFFFFFFFFFFFFFFMMMMMMMMMMMMMMMMMMMMM"
    "GGGGGGGGGGGGGGGMMMMFFFFFFFFFFFFFFMMMMMMMMMMMMMMMMMMMMMMM"
    "GGGGGGGGGGGGGGGGMMMMFFFFFFFFFFFFMMMMMMMMMMMMMMMMMMMMMMMM"
    "GGGGGGGGGGGGGGGGGGMMMFFFFFFFFMMMMMMMMMMMMMMMMMMMMMMMMMMM"
    "GGGGGGGGGGGGGGGGGGGMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM"
    "GGGGGGGGGGGGGGGGGGGGMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM"
    "GGGGGGGGGGGGGGGGGGGGGMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM"
    "GGGGGGGGGGGGGGGGGGGGGGGGMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM"
    "GGGGGGGGGGGGGGGGGGGGGGGGGGMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM"
    "GGGGGGGGGGGGGGGGGGGGGGGGGGMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM"
    "GGGGGGGGGGGGGGGGGGGGGGGGGGMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM"
  )
end

;; Function to create Infantry turtles.
;;
;; Input:
;;   _number - How many to initialize
;;   _side   - Who does this agent fight for?
to init_infantry
  [_number _side]
  create-infantrys _number [
    setxy random-xcor random-ycor
    set shape "person"
    set side _side
    set kind "infantry"
    set health infantry_init_health
    set speed infantry_speed
    set rate infantry_hit_rate * 100
    set accuracy infantry_hit_accuracy
    set dist infantry_hit_distance
    ifelse _side = "ARM" [
      set color arm_color
      set in-city? true
    ] [
      set color aze_color
      set in-city? false
    ]
    if _side = "ARM" [
      setxy 15 + random 25  23 + random 13
    ]
    if _side = "AZE" and who mod 3 = 1 [
      setxy 51 + random 4 17 + random 28
    ]
    if _side = "AZE" and who mod 3 = 2 [
      setxy 2 + random 4 17 + random 28
    ]
    if _side = "AZE" and who mod 3 = 0 [
      setxy 15 + random 25 2 + random 4
    ]
  ]
end

;; Function to create Artillery turtles.
;;
;; Input:
;;   _number - How many to initialize
;;   _side   - Who does this agent fight for?
to init_artillery
  [_number _side]
  create-artillerys _number [
    setxy random-xcor random-ycor
    set shape "circle 2"
    set side _side
    set kind "artillery"
    set health artillery_init_health
    set speed 0
    set rate artillery_hit_rate * 100
    set accuracy artillery_hit_accuracy
    set dist artillery_hit_distance
    set targets []
    ifelse _side = "ARM"
      [ set color arm_color ]
      [ set color aze_color ]
    if _side = "ARM" [
      setxy 19 + random 15  41 + random 4
    ]
    if _side = "AZE" and who mod 1 = 0 [
      setxy 51 + random 4 17 + random 28
    ]
    if _side = "AZE" and who mod 3 = 0 [
      setxy 2 + random 4 17 + random 28
    ]
    if _side = "AZE" and who mod 2 = 0 [
      setxy 15 + random 25 2 + random 4
    ]
  ]
end

;; Function to create Drone turtles.
;;
;; Input:
;;   _number - How many to initialize
;;   _side   - Who does this agent fight for?
to init_drone
  [_number _side]
  create-drones _number [
    setxy random-xcor random-ycor
    set shape "airplane"
    set side _side
    set kind "drone"
    set health 1
    set speed drone_speed
    set rate drone_view_rate * 100
    set dist drone_view_distance
    ifelse _side = "ARM"
      [ set color arm_color ]
      [ set color aze_color ]

    if _side = "ARM" [
      setxy 16 + random 23  19 + random 21
      set accuracy 0.75
    ]
    if _side = "AZE"  [
      setxy 51 + random 4 17 + random 28
      set accuracy 0.95
    ]
  ;  if _side = "AZE" and who mod 1 = 0 [
  ;    setxy 51 + random 4 17 + random 28
  ;  ]
  ;  if _side = "AZE" and who mod 3 = 0 [
  ;    setxy 2 + random 4 17 + random 28
  ;   ]
  ;  if _side = "AZE" and who mod 2 = 0 [
  ;    setxy 15 + random 25 2 + random 4
  ;  ]
    set heading (towards patch 27 27) + random 90 - 45
  ]
end

;; Initializes forces for Azerbaijan
to init_azerbaijan
  init_infantry aze_infantry_count "AZE"
  init_artillery aze_artillery_count "AZE"
  init_drone aze_drone_count "AZE"
end

;; Initializes forces for Armenia
to init_armenia
  init_infantry arm_infantry_count "ARM"
  init_artillery arm_artillery_count "ARM"
  init_drone arm_drone_count "ARM"
end

;; Initializes patches
to init_patches
  [sim_map dim]
  if display_shusha_map [
    import-drawing "Shusha-alpha.png"
  ]
  ;; color patches
  ask patches [
    set patch_pos (item (pxcor + (pycor * dim)) sim_map)
    if patch_pos = "F" [
      set pcolor flat_color
      set environment "flat"
      set mod_infantry_speed 1
      set mod_infantry_acc 1
      set mod_artillery_acc 1
      set mod_artillery_acc_d 2
      set mod_drone_acc 1
      set fog_density 0
    ]
    if patch_pos = "G" [
      set pcolor forest_color
      set environment "forest"
      set mod_infantry_speed 0.5
      set mod_infantry_acc 0.5
      set mod_artillery_acc 0.5
      set mod_artillery_acc_d 1
      set mod_drone_acc 0.25
      set fog_density 0
    ]
    if patch_pos = "R" [
      set pcolor river_color
      set environment "river"
      set mod_infantry_speed 0.25
      set mod_infantry_acc 2
      set mod_artillery_acc 2
      set mod_artillery_acc_d 2
      set mod_drone_acc 1
      set fog_density 0
    ]
    if patch_pos = "M" [
      set pcolor mountain_color
      set environment "mountain"
      set mod_infantry_speed 0.125
      set mod_infantry_acc 0.3
      set mod_artillery_acc 0.125
      set mod_artillery_acc_d 0.25
      set mod_drone_acc 0.75
      set fog_density 0
    ]
  ]
end

to-report fog-covering
  [ desiredSide ]
  report sum [health] of (turtles-on (patches with [fog_density != 0] )) with [kind = "infantry" and side = desiredSide]
;;  ask patches [
;;    ifelse fog_density = 0 [
;;      set covering_count 0
;;    ] [
;;      set covering_count sum [health] of infantrys with [xcor = pxcor and ycor = pycor and side = desiredSide]
;;    ]
;;  ]
;;  report sum [covering_count] of patches
end

;; reports over whole map
to-report overall-fog-density
  report (sum [fog_density] of patches) / (count patches)
end

to-report infantry-total
  [aSide]
  report (sum [health] of infantrys with [side = aSide])
end

to move_fog
  ask patches [
    let x pxcor
    ifelse x != 0 [
      let neighbor_fog [old_density] of patch (x - 1) pycor
      set pcolor (pcolor + (fog_density * 4)) - (neighbor_fog * 4)
      set fog_density neighbor_fog
    ] [
      if fog_density > 0 [
        set pcolor pcolor + 1
        set fog_density fog_density - 0.25
      ]
    ]
  ]
end

to finalize_fog_step
  ask patches [
    set old_density fog_density
  ]
end

;; spread clustered fog
to spread_fog
  [ thisPatch density ]
  if density != 0 [ ;; ensure density passed is actually something to use
    ask thisPatch [
      let mult 4 * (density - fog_density) ;; 4 * [ 0.25, 0.5, 0.75, or 1 ]
      set pcolor pcolor - (mult)           ;; increasing color makes it more close to white
      ;; Set stuff. I used power (^ mult) since the higher the density (0.9^4) would have
      ;; more effects than lower density (0.9^1)
      set fog_density density
      set old_density density
      ;; ask 8 neighbors, (could use 'neighbors4' if you want
      ask neighbors [
        let d density
        if overall-fog-density > fog_coverage [ ;; check if we should stop
          set d d - 0.25
        ]
        if d > fog_density [
          spread_fog self (min (list 1 d))   ;; recurse
        ]
      ]
    ]
  ]
end

;; continue spreading fog until limit is met
to init_fog
  while [overall-fog-density < fog_coverage] [
    spread_fog (one-of patches) 1
  ]
end

to provide-recon
  [ thisDrone ]
  let mySide [side] of thisDrone
  let thisArtillery closest_artillery_friend thisDrone
  let enemy drone_view_enemy thisDrone
  if enemy != nobody [
    ask thisArtillery [
      set targets lput enemy targets
    ]
  ]
end

to-report drone_view_enemy
  [ thisTurtle ]
  let mySide [side] of thisTurtle
  let spotted closest_infantry_enemy thisTurtle
  if nobody != spotted [
    if (drone_view_accuracy * mod_drone_acc * (0.5 ^ (4 * fog_density)) ) >= random-float 1 [
      ifelse mySide = "AZE" [
        set AZE_drone_spots AZE_drone_spots + 1
      ] [
        set ARM_drone_spots ARM_drone_spots + 1
      ]
      report spotted
    ]
  ]
  report nobody
end

to-report closest_artillery_friend
  [ thisTurtle ]
  let mySide [side] of thisTurtle
  report min-one-of artillerys with [side = mySide] [distance thisTurtle]
end

to-report closest_infantry_enemy
  [ thisTurtle ]
  let mySide [side] of thisTurtle
  let closest min-one-of infantrys with [side != mySide] [distance thisTurtle]
  ifelse distance closest <= dist
    [ report closest ]
    [ report nobody ]
end

to-report city_center
  [ thisTurtle ]
  report min-one-of patches with [ pxcor  >= 24 and pxcor < 32 and pycor >= 28 and pycor < 36 ] [ distance thisTurtle ]
  end

to turn-towards-center
  [ thisDrone ]
  ask thisDrone [
    let change 0
    if side = "ARM" [
      set change 0
    ]
    let current heading
    face city_center self
    let target heading
    let alpha target - current
    let beta alpha + 360
    let gamma alpha - 360
    if (abs alpha <= abs beta and abs alpha <= abs gamma) [
      ifelse alpha > 0
        [ set heading current + change ]
        [ set heading current - change ]
    ]
    if (abs beta <= abs alpha and abs beta <= abs gamma) [
      ifelse beta > 0
        [ set heading current + change ]
        [ set heading current - change ]
    ]
    if (abs gamma <= abs alpha and abs gamma <= abs beta) [
      ifelse gamma > 0
        [ set heading current + change ]
        [ set heading current - change ]
    ]
  ]
end

to move
  ask infantrys [
    ifelse side = "AZE" [
      let enemy closest_infantry_enemy self
      ifelse enemy != nobody [
        face enemy
        attack self enemy
      ] [
        face city_center self
      ]
      forward mod_infantry_speed * speed / 100 * (0.9 ^ (4 * fog_density))

    ] [
      let enemy closest_infantry_enemy self
      if enemy != nobody [
        face enemy
        attack self enemy
        forward mod_infantry_speed * speed / 100 * (0.9 ^ (4 * fog_density))
      ]
    ]
  ]
  ask drones [
    if pxcor = max-pxcor  [
      setxy (min-pxcor + 1) (max-pycor - pycor)
      face city_center self
    ]
        if pxcor = min-pxcor  [
      setxy (max-pxcor - 1) (max-pycor - pycor)
      face city_center self
   ]
        if pycor = max-pycor  [
      setxy (max-pxcor - pxcor) (min-pycor + 1)
      face city_center self
    ]
        if pycor = min-pycor [
      setxy (max-pxcor - pxcor) (max-pycor - 1)
      face city_center self
    ]
    turn-towards-center self
    if random-float 1 < 0.5 [
      ifelse random-float 1 < 0.5
        [ rt random-float 10 - 5 ]
        [ lt random-float 10 - 5 ]
    ]
    forward speed / 100
    provide-recon self
  ]
  ask artillerys [
    if not empty? targets [
      let target first targets
      set targets []
      attack self target
    ]
  ]

end

to suffer_damage
  [ thisTurtle acc power responsible ]
  repeat power [
    if thisTurtle != nobody [
      ask thisTurtle [
        if acc >= random-float 1 [
          set health health - 1
          if responsible = "ARM_infantry" [
            set ARM_infantry_kills ARM_infantry_kills + 1
          ]
          if responsible = "AZE_infantry" [
            set AZE_infantry_kills AZE_infantry_kills + 1
          ]
          if responsible = "ARM_artillery" [
            set ARM_artillery_kills ARM_artillery_kills + 1
          ]
          if responsible = "AZE_artillery" [
            set AZE_artillery_kills AZE_artillery_kills + 1
          ]
          if health <= 0 [
            die
          ]
        ]
      ]
    ]
  ]
end

to attack
  [ thisTurtle enemyTurtle ]

  if enemyTurtle != nobody [

    let thisKind [kind] of thisTurtle
    let enemyKind [kind] of enemyTurtle
    let thisSide [side] of thisTurtle
    let enemySide [side] of enemyTurtle
    let power [health] of thisTurtle
    let r [rate] of thisTurtle

    if ticks mod r = 0 [
      if thisSide != enemySide [ ;; Should never be false, but for safety
        if thisKind = "infantry" and enemyKind = "infantry" [
          suffer_damage enemyTurtle (mod_infantry_acc * accuracy * (0.9 ^ (4 * fog_density)) ) power (word thisSide "_" thisKind)
        ]
        if thisKind = "artillery" and enemyKind = "infantry" [
          let loc_x [xcor] of enemyTurtle
          let loc_y [ycor] of enemyTurtle
          ask infantrys with [xcor = loc_x and ycor = loc_y] [
            suffer_damage enemyTurtle (mod_artillery_acc * accuracy * (0.9 ^ (4 * fog_density)) ) power (word thisSide "_" thisKind)
          ]
        ]
      ]
    ]
  ]
end

to-report to_percent
  [in]
  let out (word round (in * 100))
  report (word out "%")
end


to setup
  clear-all
  set_globals
  init_patches sim_map_56 56
  init_fog ;; must call after `init_patches`
  init_azerbaijan
  init_armenia
  reset-ticks
end

to go
  let remaining_ARM count infantrys with [side = "ARM"]
  let remaining_AZE count infantrys with [side = "AZE"]

  if remaining_ARM < 5 or remaining_AZE < 5 [
    let aze_won? remaining_AZE > remaining_ARM
    let winner "ARM"
    let loser "AZE"
    if aze_won? [
      set winner "AZE"
      set loser "ARM"
    ]
    user-message (word loser " has retreated.\n\n" winner " is the winner")
    stop
  ]

  move
  if (ticks mod fog_speed) = fog_speed - 1 [
    move_fog
    finalize_fog_step
  ]
  tick
end
@#$#@#$#@
GRAPHICS-WINDOW
716
10
1401
696
-1
-1
12.1
1
10
1
1
1
0
0
0
1
0
55
0
55
1
1
1
ticks
30.0

BUTTON
583
24
648
57
Go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

BUTTON
513
24
579
57
Setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

TEXTBOX
26
16
176
34
Agent Configuration
11
0.0
1

SLIDER
0
34
180
67
infantry_init_health
infantry_init_health
1
100
20.0
1
1
NIL
HORIZONTAL

SLIDER
0
68
180
101
infantry_speed
infantry_speed
0
50
10.0
1
1
NIL
HORIZONTAL

SLIDER
0
102
180
135
infantry_hit_rate
infantry_hit_rate
0
1
0.1
0.01
1
NIL
HORIZONTAL

SLIDER
0
136
180
169
infantry_hit_accuracy
infantry_hit_accuracy
0
1
0.1
0.01
1
NIL
HORIZONTAL

SLIDER
0
169
180
202
infantry_hit_distance
infantry_hit_distance
1
100
5.0
1
1
NIL
HORIZONTAL

SLIDER
0
366
180
399
artillery_init_health
artillery_init_health
1
100
50.0
1
1
NIL
HORIZONTAL

SLIDER
0
399
180
432
artillery_hit_rate
artillery_hit_rate
0
1
0.25
0.01
1
NIL
HORIZONTAL

SLIDER
0
431
180
464
artillery_hit_accuracy
artillery_hit_accuracy
0
1
1.0
0.01
1
NIL
HORIZONTAL

SLIDER
0
463
180
496
artillery_hit_distance
artillery_hit_distance
1
100
30.0
1
1
NIL
HORIZONTAL

SLIDER
0
234
180
267
drone_speed
drone_speed
1
50
50.0
1
1
NIL
HORIZONTAL

SLIDER
0
267
180
300
drone_view_rate
drone_view_rate
0
1
0.25
0.01
1
NIL
HORIZONTAL

SLIDER
0
300
180
333
drone_view_accuracy
drone_view_accuracy
0
1
0.95
0.01
1
NIL
HORIZONTAL

SLIDER
0
334
180
367
drone_view_distance
drone_view_distance
1
100
10.0
1
1
NIL
HORIZONTAL

SLIDER
484
66
670
99
fog_coverage
fog_coverage
0
1
0.0
0.01
1
NIL
HORIZONTAL

MONITOR
372
149
490
194
AZE Infantry
sum [health] of turtles with [ side = \"AZE\" and kind = \"infantry\" ]
17
1
11

MONITOR
490
149
613
194
ARM Infantry
sum [health] of turtles with [ side = \"ARM\" and kind = \"infantry\" ]
17
1
11

MONITOR
490
194
613
239
ARM Infantry Kills
ARM_infantry_kills
17
1
11

MONITOR
372
194
490
239
AZE Infantry Kills
AZE_infantry_kills
17
1
11

MONITOR
490
239
613
284
ARM Artillery Kills
ARM_artillery_kills
17
1
11

MONITOR
372
239
490
284
AZE Artillery Kills
AZE_artillery_kills
17
1
11

PLOT
280
401
491
551
Infantry Remaining
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"ARM" 1.0 0 -8053223 true "" "plot infantry-total \"ARM\""
"AZE" 1.0 0 -14985354 true "" "plot infantry-total \"AZE\""

SWITCH
484
99
670
132
display_shusha_map
display_shusha_map
1
1
-1000

MONITOR
372
285
489
330
AZE Drone Spots
AZE_drone_spots
17
1
11

MONITOR
489
285
613
330
ARM Drone Spots
ARM_drone_spots
17
1
11

MONITOR
372
331
489
376
AZE Spot:Kill
to_percent (AZE_artillery_kills / AZE_drone_spots)
17
1
11

MONITOR
488
331
613
376
ARM Spot:Kill
to_percent (ARM_artillery_kills / ARM_drone_spots)
17
1
11

CHOOSER
313
99
485
144
troop_count_scenario
troop_count_scenario
"AZE_Reported" "ARM_Reported" "Equal"
2

SLIDER
313
66
485
99
fog_speed
fog_speed
0
50
36.0
1
1
NIL
HORIZONTAL

PLOT
491
550
701
702
Drone Spots
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"AZE" 1.0 0 -14070903 true "" "plot AZE_drone_spots"
"ARM" 1.0 0 -8053223 true "" "plot ARM_drone_spots"

PLOT
490
401
701
551
Fog Covering Infantry
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"AZE" 1.0 0 -14454117 true "" "plot fog-covering \"AZE\""
"ARM" 1.0 0 -8053223 true "" "plot fog-covering \"ARM\""

PLOT
280
551
491
701
Artillery Kills
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"AZE" 1.0 0 -13345367 true "" "plot AZE_artillery_kills"
"pen-1" 1.0 0 -2674135 true "" "plot ARM_artillery_kills"

@#$#@#$#@
## TODO
 - Initial Placement of troops
 - Agent Movement
 - Agent Interaction

## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.2.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experiment" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <metric>AZE_artillery_kills</metric>
    <metric>ARM_artillery_kills</metric>
    <metric>AZE_drone_spots</metric>
    <metric>ARM_drone_spots</metric>
    <metric>fog-covering "AZE"</metric>
    <metric>fog-covering "ARM"</metric>
    <metric>infantry-total "AZE"</metric>
    <metric>infantry-total "ARM"</metric>
    <enumeratedValueSet variable="fog_coverage">
      <value value="0"/>
      <value value="0.1"/>
      <value value="0.2"/>
      <value value="0.3"/>
      <value value="0.4"/>
      <value value="0.5"/>
      <value value="0.6"/>
      <value value="0.7"/>
      <value value="0.8"/>
      <value value="0.9"/>
      <value value="1"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
