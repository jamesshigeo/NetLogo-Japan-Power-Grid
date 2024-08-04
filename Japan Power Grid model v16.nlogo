extensions [ csv ]
globals [
  day
  hour
  current-hour

  total-supply
  total-demand

  max-capacity-hokkaido
  max-capacity-tohoku
  max-capacity-tokyo
  max-capacity-chubu
  max-capacity-hokuriku
  max-capacity-kansai
  max-capacity-chugoku
  max-capacity-shikoku
  max-capacity-kyushu

  wind-proportion-hokkaido
  solar-proportion-hokkaido
  OSW-proportion-hokkaido
  hydro-proportion-hokkaido
  fossil-fuel-proportion-hokkaido
  others-proportion-hokkaido
  nuclear-proportion-hokkaido

  wind-proportion-tohoku
  solar-proportion-tohoku
  OSW-proportion-tohoku
  hydro-proportion-tohoku
  fossil-fuel-proportion-tohoku
  others-proportion-tohoku
  nuclear-proportion-tohoku

  wind-proportion-tokyo
  solar-proportion-tokyo
  OSW-proportion-tokyo
  hydro-proportion-tokyo
  fossil-fuel-proportion-tokyo
  others-proportion-tokyo
  nuclear-proportion-tokyo

  wind-proportion-chubu
  solar-proportion-chubu
  OSW-proportion-chubu
  hydro-proportion-chubu
  fossil-fuel-proportion-chubu
  others-proportion-chubu
  nuclear-proportion-chubu

  wind-proportion-hokuriku
  solar-proportion-hokuriku
  OSW-proportion-hokuriku
  hydro-proportion-hokuriku
  fossil-fuel-proportion-hokuriku
  others-proportion-hokuriku
  nuclear-proportion-hokuriku

  wind-proportion-kansai
  solar-proportion-kansai
  OSW-proportion-kansai
  hydro-proportion-kansai
  fossil-fuel-proportion-kansai
  others-proportion-kansai
  nuclear-proportion-kansai

  wind-proportion-chugoku
  solar-proportion-chugoku
  OSW-proportion-chugoku
  hydro-proportion-chugoku
  fossil-fuel-proportion-chugoku
  others-proportion-chugoku
  nuclear-proportion-chugoku

  wind-proportion-shikoku
  solar-proportion-shikoku
  OSW-proportion-shikoku
  hydro-proportion-shikoku
  fossil-fuel-proportion-shikoku
  others-proportion-shikoku
  nuclear-proportion-shikoku

  wind-proportion-kyushu
  solar-proportion-kyushu
  OSW-proportion-kyushu
  hydro-proportion-kyushu
  fossil-fuel-proportion-kyushu
  others-proportion-kyushu
  nuclear-proportion-kyushu

  hokkaido-demand-list
  tohoku-demand-list
  tokyo-demand-list
  chubu-demand-list
  hokuriku-demand-list
  kansai-demand-list
  chugoku-demand-list
  shikoku-demand-list
  kyushu-demand-list

  storage-capacity-hokkaido
  storage-capacity-tohoku
  storage-capacity-tokyo
  storage-capacity-chubu
  storage-capacity-hokuriku
  storage-capacity-kansai
  storage-capacity-chugoku
  storage-capacity-shikoku
  storage-capacity-kyushu

  storage-max-output-hokkaido
  storage-max-output-tohoku
  storage-max-output-tokyo
  storage-max-output-chubu
  storage-max-output-hokuriku
  storage-max-output-kansai
  storage-max-output-chugoku
  storage-max-output-shikoku
  storage-max-output-kyushu

  adjusted-supply-hokkaido
  adjusted-supply-tohoku
  adjusted-supply-tokyo
  adjusted-supply-chubu
  adjusted-supply-hokuriku
  adjusted-supply-kansai
  adjusted-supply-chugoku
  adjusted-supply-shikoku
  adjusted-supply-kyushu

  storage-contribution-hokkaido
  storage-contribution-tohoku
  storage-contribution-tokyo
  storage-contribution-chubu
  storage-contribution-hokuriku
  storage-contribution-kansai
  storage-contribution-chugoku
  storage-contribution-shikoku
  storage-contribution-kyushu

  total-adjusted-supply-hokkaido
  total-adjusted-supply-tohoku
  total-adjusted-supply-tokyo
  total-adjusted-supply-chubu
  total-adjusted-supply-hokuriku
  total-adjusted-supply-kansai
  total-adjusted-supply-chugoku
  total-adjusted-supply-shikoku
  total-adjusted-supply-kyushu

  hokkaido-tohoku-transport
  tohoku-tokyo-transport
  tokyo-chubu-transport
  chubu-hokuriku-transport
  kansai-hokuriku-transport
  kansai-chubu-transport
  kansai-chugoku-transport
  kansai-shikoku-transport
  chugoku-shikoku-transport
  chugoku-kyushu-transport

]


breed [supplys supply]
breed [demands demand]
breed [storages storage]


supplys-own [
  electricity-generation
  supply-type
  supply-region
  supply-category
]


demands-own [
  electricity-demand
  demand-region
  demand-list
  import-amount
  export-amount
]



storages-own [
  electricity-stored
  individual-storage
  storage-region
  storage-max-output
  storage-contribution
]


patches-own [
  is-land
]


links-own [
  max-transmission-capacity
]


to setup
  clear-all
  setup-japan
  load-demand-data
  create-demand-agents
  create-supply-agents
  create-storage-agents
  setup-links
  reset-ticks
end


to setup-japan
  import-pcolors "Japan outline (square) 150x150.png"
  configure-patches
  initialize-variables
  initialize-thermal-generation
end


to configure-patches
  ask patches [
    ifelse pcolor = black [
      set pcolor green
      set is-land true
    ] [
      set pcolor blue
      set is-land false
    ]
  ]
  smooth-edges
end

to load-demand-data
  set hokkaido-demand-list extract-demand-column "hokkaido_2023 data.csv"
  set tohoku-demand-list extract-demand-column "tohoku_2023 data.csv"
  set tokyo-demand-list extract-demand-column "tokyo_2023 data.csv"
  set chubu-demand-list extract-demand-column "chubu_2023 data.csv"
  set hokuriku-demand-list extract-demand-column "hokuriku_2023 data.csv"
  set kansai-demand-list extract-demand-column "kansai_2023 data.csv"
  set chugoku-demand-list extract-demand-column "chugoku_2023 data.csv"
  set shikoku-demand-list extract-demand-column "shikoku_2023 data.csv"
  set kyushu-demand-list extract-demand-column "kyushu_2023 data.csv"
end


to-report extract-demand-column [file-name]
  let data csv:from-file file-name
  let demand-column but-first but-first map [column -> item 15 column] data
  report demand-column
end


to create-demand-agents
  create-demand-agent "Hokkaido" 39 47
  create-demand-agent "Tohoku" 24 8
  create-demand-agent "Tokyo" 17 -17
  create-demand-agent "Chubu" 3 -26
  create-demand-agent "Hokuriku" 3 -15
  create-demand-agent "Kansai" -11 -28
  create-demand-agent "Chugoku" -31 -31
  create-demand-agent "Shikoku" -26 -39
  create-demand-agent "Kyushu" -45 -45
end

to create-demand-agent [region x y]
  create-demands 1 [
    setxy x y
    set shape "circle"
    set color gray
    set size 3
    set demand-region region
    if demand-region = "Hokkaido" [set demand-list hokkaido-demand-list]
    if demand-region = "Tohoku" [set demand-list tohoku-demand-list]
    if demand-region = "Tokyo" [set demand-list tokyo-demand-list]
    if demand-region = "Chubu" [set demand-list chubu-demand-list]
    if demand-region = "Hokuriku" [set demand-list hokuriku-demand-list]
    if demand-region = "Kansai" [set demand-list kansai-demand-list]
    if demand-region = "Chugoku" [set demand-list chugoku-demand-list]
    if demand-region = "Shikoku" [set demand-list shikoku-demand-list]
    if demand-region = "Kyushu" [set demand-list kyushu-demand-list]
  ]
end


to initialize-variables

  set max-capacity-hokkaido max-capacity-hokkaido-input
  set max-capacity-tohoku max-capacity-tohoku-input
  set max-capacity-tokyo max-capacity-tokyo-input
  set max-capacity-chubu max-capacity-chubu-input
  set max-capacity-hokuriku max-capacity-hokuriku-input
  set max-capacity-kansai max-capacity-kansai-input
  set max-capacity-chugoku max-capacity-chugoku-input
  set max-capacity-shikoku max-capacity-shikoku-input
  set max-capacity-kyushu max-capacity-kyushu-input

  set fossil-fuel-proportion-hokkaido fossil-fuel-proportion-hokkaido-slider
  set nuclear-proportion-hokkaido nuclear-proportion-hokkaido-slider
  set wind-proportion-hokkaido wind-proportion-hokkaido-slider
  set solar-proportion-hokkaido solar-proportion-hokkaido-slider
  set OSW-proportion-hokkaido OSW-proportion-hokkaido-slider
  set hydro-proportion-hokkaido hydro-proportion-hokkaido-slider
  set others-proportion-hokkaido others-proportion-hokkaido-slider

  set fossil-fuel-proportion-tohoku fossil-fuel-proportion-tohoku-slider
  set nuclear-proportion-tohoku nuclear-proportion-tohoku-slider
  set wind-proportion-tohoku wind-proportion-tohoku-slider
  set solar-proportion-tohoku solar-proportion-tohoku-slider
  set OSW-proportion-tohoku OSW-proportion-tohoku-slider
  set hydro-proportion-tohoku hydro-proportion-tohoku-slider
  set others-proportion-tohoku others-proportion-tohoku-slider

  set fossil-fuel-proportion-tokyo fossil-fuel-proportion-tokyo-slider
  set nuclear-proportion-tokyo nuclear-proportion-tokyo-slider
  set wind-proportion-tokyo wind-proportion-tokyo-slider
  set solar-proportion-tokyo solar-proportion-tokyo-slider
  set OSW-proportion-tokyo OSW-proportion-tokyo-slider
  set hydro-proportion-tokyo hydro-proportion-tokyo-slider
  set others-proportion-tokyo others-proportion-tokyo-slider

  set fossil-fuel-proportion-chubu fossil-fuel-proportion-chubu-slider
  set nuclear-proportion-chubu nuclear-proportion-chubu-slider
  set wind-proportion-chubu wind-proportion-chubu-slider
  set solar-proportion-chubu solar-proportion-chubu-slider
  set OSW-proportion-chubu OSW-proportion-chubu-slider
  set hydro-proportion-chubu hydro-proportion-chubu-slider
  set others-proportion-chubu others-proportion-chubu-slider

  set fossil-fuel-proportion-hokuriku fossil-fuel-proportion-hokuriku-slider
  set nuclear-proportion-hokuriku nuclear-proportion-hokuriku-slider
  set wind-proportion-hokuriku wind-proportion-hokuriku-slider
  set solar-proportion-hokuriku solar-proportion-hokuriku-slider
  set OSW-proportion-hokuriku OSW-proportion-hokuriku-slider
  set hydro-proportion-hokuriku hydro-proportion-hokuriku-slider
  set others-proportion-hokuriku others-proportion-hokuriku-slider

  set fossil-fuel-proportion-kansai fossil-fuel-proportion-kansai-slider
  set nuclear-proportion-kansai nuclear-proportion-kansai-slider
  set wind-proportion-kansai wind-proportion-kansai-slider
  set solar-proportion-kansai solar-proportion-kansai-slider
  set OSW-proportion-kansai OSW-proportion-kansai-slider
  set hydro-proportion-kansai hydro-proportion-kansai-slider
  set others-proportion-kansai others-proportion-kansai-slider

  set fossil-fuel-proportion-chugoku fossil-fuel-proportion-chugoku-slider
  set nuclear-proportion-chugoku nuclear-proportion-chugoku-slider
  set wind-proportion-chugoku wind-proportion-chugoku-slider
  set solar-proportion-chugoku solar-proportion-chugoku-slider
  set OSW-proportion-chugoku OSW-proportion-chugoku-slider
  set hydro-proportion-chugoku hydro-proportion-chugoku-slider
  set others-proportion-chugoku others-proportion-chugoku-slider

  set fossil-fuel-proportion-shikoku fossil-fuel-proportion-shikoku-slider
  set nuclear-proportion-shikoku nuclear-proportion-shikoku-slider
  set wind-proportion-shikoku wind-proportion-shikoku-slider
  set solar-proportion-shikoku solar-proportion-shikoku-slider
  set OSW-proportion-shikoku OSW-proportion-shikoku-slider
  set hydro-proportion-shikoku hydro-proportion-shikoku-slider
  set others-proportion-shikoku others-proportion-shikoku-slider

  set fossil-fuel-proportion-kyushu fossil-fuel-proportion-kyushu-slider
  set nuclear-proportion-kyushu nuclear-proportion-kyushu-slider
  set wind-proportion-kyushu wind-proportion-kyushu-slider
  set solar-proportion-kyushu solar-proportion-kyushu-slider
  set OSW-proportion-kyushu OSW-proportion-kyushu-slider
  set hydro-proportion-kyushu hydro-proportion-kyushu-slider
  set others-proportion-kyushu others-proportion-kyushu-slider

  set storage-capacity-hokkaido storage-capacity-hokkaido-input
  set storage-capacity-tohoku storage-capacity-tohoku-input
  set storage-capacity-tokyo storage-capacity-tokyo-input
  set storage-capacity-chubu storage-capacity-chubu-input
  set storage-capacity-hokuriku storage-capacity-hokuriku-input
  set storage-capacity-kansai storage-capacity-kansai-input
  set storage-capacity-chugoku storage-capacity-chugoku-input
  set storage-capacity-shikoku storage-capacity-shikoku-input
  set storage-capacity-kyushu storage-capacity-kyushu-input

  set storage-max-output-hokkaido storage-max-output-hokkaido-input
  set storage-max-output-tohoku storage-max-output-tohoku-input
  set storage-max-output-tokyo storage-max-output-tokyo-input
  set storage-max-output-chubu storage-max-output-chubu-input
  set storage-max-output-hokuriku storage-max-output-hokuriku-input
  set storage-max-output-kansai storage-max-output-kansai-input
  set storage-max-output-chugoku storage-max-output-chugoku-input
  set storage-max-output-shikoku storage-max-output-shikoku-input
  set storage-max-output-kyushu storage-max-output-kyushu-input


end

to initialize-thermal-generation
  ask supplys with [supply-category = "thermal"] [
    set electricity-generation 0
  ]
end

to create-supply-agents

  create-supply-agent "Hokkaido" "fossil-fuel" "thermal" 42 51 0 red
  create-supply-agent "Hokkaido" "nuclear" "baseload" 44 49 0 orange
  create-supply-agent "Hokkaido" "wind" "baseload" 39 52 0 white
  create-supply-agent "Hokkaido" "solar" "solar" 35 50 0 yellow
  create-supply-agent "Hokkaido" "hydro" "baseload" 44 45 0 blue
  create-supply-agent "Hokkaido" "others" "baseload" 42 43 0 pink
  create-supply-agent "Hokkaido" "OSW" "baseload" 25 49 0 cyan

  create-supply-agent "Tohoku" "fossil-fuel" "thermal" 29 10 0 red
  create-supply-agent "Tohoku" "nuclear" "baseload" 28 7 0 orange
  create-supply-agent "Tohoku" "wind" "baseload" 27 3 0 white
  create-supply-agent "Tohoku" "solar" "solar" 24 14 0 yellow
  create-supply-agent "Tohoku" "hydro" "baseload" 20 9 0 blue
  create-supply-agent "Tohoku" "others" "baseload" 19 7 0 pink
  create-supply-agent "Tohoku" "OSW" "baseload" 16 13 0 cyan

  create-supply-agent "Tokyo" "fossil-fuel" "thermal" 14 -23 0 red
  create-supply-agent "Tokyo" "nuclear" "baseload" 14 -13 0 orange
  create-supply-agent "Tokyo" "wind" "baseload" 21 -14 0 white
  create-supply-agent "Tokyo" "solar" "solar" 21 -21 0 yellow
  create-supply-agent "Tokyo" "hydro" "baseload" 17 -22 0 blue
  create-supply-agent "Tokyo" "others" "baseload" 19 -22 0 pink
  create-supply-agent "Tokyo" "OSW" "baseload" 25 -16 0 cyan

  create-supply-agent "Chubu" "fossil-fuel" "thermal" 0 -29 0 red
  create-supply-agent "Chubu" "nuclear" "baseload" 5 -22 0 orange
  create-supply-agent "Chubu" "wind" "baseload" 0 -23 0 white
  create-supply-agent "Chubu" "solar" "solar" 9 -26 0 yellow
  create-supply-agent "Chubu" "hydro" "baseload" 3 -30 0 blue
  create-supply-agent "Chubu" "others" "baseload" -1 -25 0 pink
  create-supply-agent "Chubu" "OSW" "baseload" 12 -32 0 cyan

  create-supply-agent "Hokuriku" "fossil-fuel" "thermal" -3 -15 0 red
  create-supply-agent "Hokuriku" "nuclear" "baseload" 5 -11 0 orange
  create-supply-agent "Hokuriku" "wind" "baseload" 3 -13 0 white
  create-supply-agent "Hokuriku" "solar" "solar" 6 -17 0 yellow
  create-supply-agent "Hokuriku" "hydro" "baseload" -1 -16 0 blue
  create-supply-agent "Hokuriku" "others" "baseload" 9 -14 0 pink
  create-supply-agent "Hokuriku" "OSW" "baseload" 2 -8 0 cyan

  create-supply-agent "Kansai" "fossil-fuel" "thermal" -8 -31 0 red
  create-supply-agent "Kansai" "nuclear" "baseload" -7 -29 0 orange
  create-supply-agent "Kansai" "wind" "baseload" -9 -24 0 white
  create-supply-agent "Kansai" "solar" "solar" -10 -36 0 yellow
  create-supply-agent "Kansai" "hydro" "baseload" -8 -34 0 blue
  create-supply-agent "Kansai" "others" "baseload" -15 -26 0 pink
  create-supply-agent "Kansai" "OSW" "baseload" -13 -23 0 cyan

  create-supply-agent "Chugoku" "fossil-fuel" "thermal" -26 -26 0 red
  create-supply-agent "Chugoku" "nuclear" "baseload" -25 -28 0 orange
  create-supply-agent "Chugoku" "wind" "baseload" -25 -32 0 white
  create-supply-agent "Chugoku" "solar" "solar" -30 -28 0 yellow
  create-supply-agent "Chugoku" "hydro" "baseload" -33 -27 0 blue
  create-supply-agent "Chugoku" "others" "baseload" -35 -31 0 pink
  create-supply-agent "Chugoku" "OSW" "baseload" -30 -24 0 cyan

  create-supply-agent "Shikoku" "fossil-fuel" "thermal" -31 -44 0 red
  create-supply-agent "Shikoku" "nuclear" "baseload" -24 -41 0 orange
  create-supply-agent "Shikoku" "wind" "baseload" -22 -39 0 white
  create-supply-agent "Shikoku" "solar" "solar" -27 -41 0 yellow
  create-supply-agent "Shikoku" "hydro" "baseload" -25 -37 0 blue
  create-supply-agent "Shikoku" "others" "baseload" -29 -41 0 pink
  create-supply-agent "Shikoku" "OSW" "baseload" -26 -44 0 cyan

  create-supply-agent "Kyushu" "fossil-fuel" "thermal" -42 -46 0 red
  create-supply-agent "Kyushu" "nuclear" "baseload" -43 -48 0 orange
  create-supply-agent "Kyushu" "wind" "baseload" -48 -46 0 white
  create-supply-agent "Kyushu" "solar" "solar" -47 -48 0 yellow
  create-supply-agent "Kyushu" "hydro" "baseload" -44 -50 0 blue
  create-supply-agent "Kyushu" "others" "baseload" -49 -44 0 pink
  create-supply-agent "Kyushu" "OSW" "baseload" -51 -39 0 cyan
end

to create-storage-agents
  create-storage-agent "Hokkaido" 36 46 storage-capacity-hokkaido storage-max-output-hokkaido magenta
  create-storage-agent "Tohoku" 21 7 storage-capacity-tohoku storage-max-output-tohoku magenta
  create-storage-agent "Tokyo" 14 -18 storage-capacity-tokyo storage-max-output-tokyo magenta
  create-storage-agent "Chubu" -1 -26 storage-capacity-chubu storage-max-output-chubu magenta
  create-storage-agent "Hokuriku" 0 -15 storage-capacity-hokuriku storage-max-output-hokuriku magenta
  create-storage-agent "Kansai" -16 -30 storage-capacity-kansai storage-max-output-kansai magenta
  create-storage-agent "Chugoku" -35 -29 storage-capacity-chugoku storage-max-output-chugoku magenta
  create-storage-agent "Shikoku" -31 -40 storage-capacity-shikoku storage-max-output-shikoku magenta
  create-storage-agent "Kyushu" -49 -52 storage-capacity-kyushu storage-max-output-kyushu magenta
end


to create-supply-agent [new-supply-region new-supply-type new-supply-category x y generation supply-color]
  create-supplys 1 [
    setxy x y
    set supply-type new-supply-type
    set supply-category new-supply-category
    set electricity-generation generation
    set color supply-color
    set shape "circle"
    set supply-region new-supply-region
  ]
end


to create-storage-agent [new-storage-region x y storage-capacity max-output storage-color]
  create-storages 1 [
    setxy x y
    set shape "square"
    set color storage-color
    set electricity-stored 0
    set individual-storage storage-capacity
    set storage-max-output max-output  ; Initialize it here
    set storage-region new-storage-region
  ]
end


to setup-links
  ask demand 0 [create-link-with demand 1 [ set max-transmission-capacity 900 ]] ; Hokkaido + Tohoku
  ask demand 1 [create-link-with demand 2 [ set max-transmission-capacity 5700 ]] ; Tohoku + Tokyo
  ask demand 2 [create-link-with demand 3 [ set max-transmission-capacity 5700 ]] ; Tokyo + Chubu
  ask demand 3 [create-link-with demand 4 [ set max-transmission-capacity 2000 ]] ; Chubu + Hokuriku
  ask demand 3 [create-link-with demand 5 [ set max-transmission-capacity 4000 ]] ; Chubu + Kansai
  ask demand 5 [create-link-with demand 4 [ set max-transmission-capacity 1500 ]] ; Kansai + Hokuriku
  ask demand 5 [create-link-with demand 6 [ set max-transmission-capacity 3500 ]] ; Kansai + Chugoku
  ask demand 5 [create-link-with demand 7 [ set max-transmission-capacity 1000 ]] ; Kansai + Shikoku
  ask demand 6 [create-link-with demand 7 [ set max-transmission-capacity 1500 ]] ; Chugoku + Shikoku
  ask demand 6 [create-link-with demand 8 [ set max-transmission-capacity 2000 ]] ; Chugoku + Kyushu

  ask supplys [
    let my-region supply-region
    let my-demand one-of demands with [demand-region = my-region]
    if my-demand != nobody [
      create-link-with my-demand [ set max-transmission-capacity 1000 set thickness 1 ] ; Example default capacity
    ]
  ]
end


to go
  if ticks >= 8760 [ stop ]

  calculate-time

  pull-data

  update-supply-and-demand

  update-electricity-generation

  manage-storage

  update-thermal-electricity-generation

  calculate-adjusted-supply

  balance-electricity

  plot-graphs

  tick
end



to calculate-time
  set day floor (ticks / 24)
  set hour ticks mod 24
  set current-hour hour
end

to pull-data
  set current-hour ((day * 24) + hour) mod length hokkaido-demand-list
  ask demands [
    set electricity-demand item current-hour demand-list
  ]
end

to update-supply-and-demand
  set total-supply (sum [electricity-generation] of supplys) +
  (sum [storage-contribution] of storages) +
  (sum [electricity-generation] of supplys with [supply-category = "thermal"])

  set total-demand sum [electricity-demand] of demands
end

to update-electricity-generation
  ask supplys [
    if supply-category = "baseload" [
      if supply-region = "Hokkaido" [
        if supply-type = "nuclear" [set electricity-generation max-capacity-hokkaido * nuclear-proportion-hokkaido]
        if supply-type = "wind" [set electricity-generation max-capacity-hokkaido * wind-proportion-hokkaido * (0.8 + random-float 0.1)]
        if supply-type = "hydro" [set electricity-generation max-capacity-hokkaido * hydro-proportion-hokkaido * (0.8 + random-float 0.1)]
        if supply-type = "others" [set electricity-generation max-capacity-hokkaido * others-proportion-hokkaido]
        if supply-type = "OSW" [set electricity-generation max-capacity-hokkaido * OSW-proportion-hokkaido * (0.8 + random-float 0.1)]
      ]
      if supply-region = "Tohoku" [
        if supply-type = "nuclear" [set electricity-generation max-capacity-tohoku * nuclear-proportion-tohoku]
        if supply-type = "wind" [set electricity-generation max-capacity-tohoku * wind-proportion-tohoku * (0.8 + random-float 0.1)]
        if supply-type = "hydro" [set electricity-generation max-capacity-tohoku * hydro-proportion-tohoku * (0.8 + random-float 0.1)]
        if supply-type = "others" [set electricity-generation max-capacity-tohoku * others-proportion-tohoku]
        if supply-type = "OSW" [set electricity-generation max-capacity-tohoku * OSW-proportion-tohoku * (0.8 + random-float 0.1)]
      ]
      if supply-region = "Tokyo" [
        if supply-type = "nuclear" [set electricity-generation max-capacity-tokyo * nuclear-proportion-tokyo]
        if supply-type = "wind" [set electricity-generation max-capacity-tokyo * wind-proportion-tokyo * (0.8 + random-float 0.1)]
        if supply-type = "hydro" [set electricity-generation max-capacity-tokyo * hydro-proportion-tokyo * (0.8 + random-float 0.1)]
        if supply-type = "others" [set electricity-generation max-capacity-tokyo * others-proportion-tokyo]
        if supply-type = "OSW" [set electricity-generation max-capacity-tokyo * OSW-proportion-tokyo * (0.8 + random-float 0.1)]
      ]
      if supply-region = "Chubu" [
        if supply-type = "nuclear" [set electricity-generation max-capacity-chubu * nuclear-proportion-chubu]
        if supply-type = "wind" [set electricity-generation max-capacity-chubu * wind-proportion-chubu * (0.8 + random-float 0.1)]
        if supply-type = "hydro" [set electricity-generation max-capacity-chubu * hydro-proportion-chubu * (0.8 + random-float 0.1)]
        if supply-type = "others" [set electricity-generation max-capacity-chubu * others-proportion-chubu]
        if supply-type = "OSW" [set electricity-generation max-capacity-chubu * OSW-proportion-chubu * (0.8 + random-float 0.1)]
      ]
      if supply-region = "Hokuriku" [
        if supply-type = "nuclear" [set electricity-generation max-capacity-hokuriku * nuclear-proportion-hokuriku]
        if supply-type = "wind" [set electricity-generation max-capacity-hokuriku * wind-proportion-hokuriku * (0.8 + random-float 0.1)]
        if supply-type = "hydro" [set electricity-generation max-capacity-hokuriku * hydro-proportion-hokuriku * (0.8 + random-float 0.1)]
        if supply-type = "others" [set electricity-generation max-capacity-hokuriku * others-proportion-hokuriku]
        if supply-type = "OSW" [set electricity-generation max-capacity-hokuriku * OSW-proportion-hokuriku * (0.8 + random-float 0.1)]
      ]
      if supply-region = "Kansai" [
        if supply-type = "nuclear" [set electricity-generation max-capacity-kansai * nuclear-proportion-kansai]
        if supply-type = "wind" [set electricity-generation max-capacity-kansai * wind-proportion-kansai * (0.8 + random-float 0.1)]
        if supply-type = "hydro" [set electricity-generation max-capacity-kansai * hydro-proportion-kansai * (0.8 + random-float 0.1)]
        if supply-type = "others" [set electricity-generation max-capacity-kansai * others-proportion-kansai]
        if supply-type = "OSW" [set electricity-generation max-capacity-kansai * OSW-proportion-kansai * (0.8 + random-float 0.1)]
      ]
      if supply-region = "Chugoku" [
        if supply-type = "nuclear" [set electricity-generation max-capacity-chugoku * nuclear-proportion-chugoku]
        if supply-type = "wind" [set electricity-generation max-capacity-chugoku * wind-proportion-chugoku * (0.8 + random-float 0.1)]
        if supply-type = "hydro" [set electricity-generation max-capacity-chugoku * hydro-proportion-chugoku * (0.8 + random-float 0.1)]
        if supply-type = "others" [set electricity-generation max-capacity-chugoku * others-proportion-chugoku]
        if supply-type = "OSW" [set electricity-generation max-capacity-chugoku * OSW-proportion-chugoku * (0.8 + random-float 0.1)]
      ]
      if supply-region = "Shikoku" [
        if supply-type = "nuclear" [set electricity-generation max-capacity-shikoku * nuclear-proportion-shikoku]
        if supply-type = "wind" [set electricity-generation max-capacity-shikoku * wind-proportion-shikoku * (0.8 + random-float 0.1)]
        if supply-type = "hydro" [set electricity-generation max-capacity-shikoku * hydro-proportion-shikoku * (0.8 + random-float 0.1)]
        if supply-type = "others" [set electricity-generation max-capacity-shikoku * others-proportion-shikoku]
        if supply-type = "OSW" [set electricity-generation max-capacity-shikoku * OSW-proportion-shikoku * (0.8 + random-float 0.1)]
      ]
      if supply-region = "Kyushu" [
        if supply-type = "nuclear" [set electricity-generation max-capacity-kyushu * nuclear-proportion-kyushu]
        if supply-type = "wind" [set electricity-generation max-capacity-kyushu * wind-proportion-kyushu * (0.8 + random-float 0.1)]
        if supply-type = "hydro" [set electricity-generation max-capacity-kyushu * hydro-proportion-kyushu * (0.8 + random-float 0.1)]
        if supply-type = "others" [set electricity-generation max-capacity-kyushu * others-proportion-kyushu]
        if supply-type = "OSW" [set electricity-generation max-capacity-kyushu * OSW-proportion-kyushu * (0.8 + random-float 0.1)]
      ]
    ]

    let sunlight-level sunlight hour

    if supply-category = "solar" [
      if supply-region = "Hokkaido" [set electricity-generation max-capacity-hokkaido * solar-proportion-hokkaido * sunlight-level]
      if supply-region = "Tohoku" [set electricity-generation max-capacity-tohoku * solar-proportion-tohoku * sunlight-level]
      if supply-region = "Tokyo" [set electricity-generation max-capacity-tokyo * solar-proportion-tokyo * sunlight-level]
      if supply-region = "Chubu" [set electricity-generation max-capacity-chubu * solar-proportion-chubu * sunlight-level]
      if supply-region = "Hokuriku" [set electricity-generation max-capacity-hokuriku * solar-proportion-hokuriku * sunlight-level]
      if supply-region = "Kansai" [set electricity-generation max-capacity-kansai * solar-proportion-kansai * sunlight-level]
      if supply-region = "Chugoku" [set electricity-generation max-capacity-chugoku * solar-proportion-chugoku * sunlight-level]
      if supply-region = "Shikoku" [set electricity-generation max-capacity-shikoku * solar-proportion-shikoku * sunlight-level]
      if supply-region = "Kyushu" [set electricity-generation max-capacity-kyushu * solar-proportion-kyushu * sunlight-level]
    ]
  ]

end

to-report sunlight [hour-of-day]
  if hour-of-day >= 4 and hour-of-day < 5 [ report 0.05 ]
  if hour-of-day >= 5 and hour-of-day < 6 [ report 0.15 ]
  if hour-of-day >= 6 and hour-of-day < 7 [ report 0.3 ]
  if hour-of-day >= 7 and hour-of-day < 8 [ report 0.55 ]
  if hour-of-day >= 8 and hour-of-day < 9 [ report 0.75 ]
  if hour-of-day >= 9 and hour-of-day < 10 [ report 0.85 ]
  if hour-of-day >= 10 and hour-of-day < 11 [ report 0.95 ]
  if hour-of-day >= 10 and hour-of-day < 11 [ report 0.98 ]
  if hour-of-day >= 11 and hour-of-day < 12 [ report 1.00 ]
  if hour-of-day >= 12 and hour-of-day < 13 [ report 0.98 ]
  if hour-of-day >= 13 and hour-of-day < 14 [ report 0.95 ]
  if hour-of-day >= 14 and hour-of-day < 15 [ report 0.85 ]
  if hour-of-day >= 15 and hour-of-day < 16 [ report 0.75 ]
  if hour-of-day >= 16 and hour-of-day < 17 [ report 0.55 ]
  if hour-of-day >= 17 and hour-of-day < 18 [ report 0.3 ]
  if hour-of-day >= 18 and hour-of-day < 19 [ report 0.15 ]
  if hour-of-day >= 19 and hour-of-day < 20 [ report 0.05 ]
  if hour-of-day >= 20 or hour-of-day < 4 [ report 0 ]
  report 0
end


to manage-storage
  ask storages [
    set storage-contribution 0
  ]

  ask storages [
    let local-supply-region storage-region
    let region-demand sum [electricity-demand] of demands with [demand-region = local-supply-region]
    let region-supply sum [electricity-generation] of supplys with [supply-region = local-supply-region]
    let adjusted-supply region-supply

    if region-supply > region-demand [
      let surplus region-supply - region-demand
      let max-charge storage-max-output
      let charge-amount min (list surplus max-charge)
      ifelse electricity-stored + charge-amount <= individual-storage [
        set electricity-stored electricity-stored + charge-amount
        set adjusted-supply region-supply - charge-amount
      ] [
        set adjusted-supply region-supply - (individual-storage - electricity-stored)
        set electricity-stored individual-storage
      ]
    ]

    if region-supply < region-demand [
      let deficit region-demand - region-supply
      let max-output storage-max-output
      if electricity-stored > 0 [
        let supply-amount min (list deficit max-output electricity-stored)
        set electricity-stored electricity-stored - supply-amount
        set adjusted-supply region-supply + supply-amount

        set storage-contribution supply-amount
      ]
    ]

    set region-supply adjusted-supply

    if local-supply-region = "Hokkaido" [ set adjusted-supply-hokkaido adjusted-supply ]
    if local-supply-region = "Tohoku" [ set adjusted-supply-tohoku adjusted-supply ]
    if local-supply-region = "Tokyo" [ set adjusted-supply-tokyo adjusted-supply ]
    if local-supply-region = "Chubu" [ set adjusted-supply-chubu adjusted-supply ]
    if local-supply-region = "Hokuriku" [ set adjusted-supply-hokuriku adjusted-supply ]
    if local-supply-region = "Kansai" [ set adjusted-supply-kansai adjusted-supply ]
    if local-supply-region = "Chugoku" [ set adjusted-supply-chugoku adjusted-supply ]
    if local-supply-region = "Shikoku" [ set adjusted-supply-shikoku adjusted-supply ]
    if local-supply-region = "Kyushu" [ set adjusted-supply-kyushu adjusted-supply ]
  ]
end


to update-thermal-electricity-generation
  let region-demands (list "Hokkaido" "Tohoku" "Tokyo" "Chubu" "Hokuriku" "Kansai" "Chugoku" "Shikoku" "Kyushu")

  foreach region-demands [
    region ->
    let region-demand sum [electricity-demand] of demands with [demand-region = region]
    let region-supply 0

    if region = "Hokkaido" [ set region-supply adjusted-supply-hokkaido ]
    if region = "Tohoku" [ set region-supply adjusted-supply-tohoku ]
    if region = "Tokyo" [ set region-supply adjusted-supply-tokyo ]
    if region = "Chubu" [ set region-supply adjusted-supply-chubu ]
    if region = "Hokuriku" [ set region-supply adjusted-supply-hokuriku ]
    if region = "Kansai" [ set region-supply adjusted-supply-kansai ]
    if region = "Chugoku" [ set region-supply adjusted-supply-chugoku ]
    if region = "Shikoku" [ set region-supply adjusted-supply-shikoku ]
    if region = "Kyushu" [ set region-supply adjusted-supply-kyushu ]

    let supply-gap region-demand - region-supply

    ask supplys with [supply-category = "thermal" and supply-region = region] [
      if region = "Hokkaido" [
        ifelse supply-gap > (max-capacity-hokkaido * fossil-fuel-proportion-hokkaido) [
          set electricity-generation max-capacity-hokkaido * fossil-fuel-proportion-hokkaido
        ] [
          set electricity-generation supply-gap
        ]
      ]
      if region = "Tohoku" [
        ifelse supply-gap > (max-capacity-tohoku * fossil-fuel-proportion-tohoku) [
          set electricity-generation max-capacity-tohoku * fossil-fuel-proportion-tohoku
        ] [
          set electricity-generation supply-gap
        ]
      ]
      if region = "Tokyo" [
        ifelse supply-gap > (max-capacity-tokyo * fossil-fuel-proportion-tokyo) [
          set electricity-generation max-capacity-tokyo * fossil-fuel-proportion-tokyo
        ] [
          set electricity-generation supply-gap
        ]
      ]
      if region = "Chubu" [
        ifelse supply-gap > (max-capacity-chubu * fossil-fuel-proportion-chubu) [
          set electricity-generation max-capacity-chubu * fossil-fuel-proportion-chubu
        ] [
          set electricity-generation supply-gap
        ]
      ]
      if region = "Hokuriku" [
        ifelse supply-gap > (max-capacity-hokuriku * fossil-fuel-proportion-hokuriku) [
          set electricity-generation max-capacity-hokuriku * fossil-fuel-proportion-hokuriku
        ] [
          set electricity-generation supply-gap
        ]
      ]
      if region = "Kansai" [
        ifelse supply-gap > (max-capacity-kansai * fossil-fuel-proportion-kansai) [
          set electricity-generation max-capacity-kansai * fossil-fuel-proportion-kansai
        ] [
          set electricity-generation supply-gap
        ]
      ]
      if region = "Chugoku" [
        ifelse supply-gap > (max-capacity-chugoku * fossil-fuel-proportion-chugoku) [
          set electricity-generation max-capacity-chugoku * fossil-fuel-proportion-chugoku
        ] [
          set electricity-generation supply-gap
        ]
      ]
      if region = "Shikoku" [
        ifelse supply-gap > (max-capacity-shikoku * fossil-fuel-proportion-shikoku) [
          set electricity-generation max-capacity-shikoku * fossil-fuel-proportion-shikoku
        ] [
          set electricity-generation supply-gap
        ]
      ]
      if region = "Kyushu" [
        ifelse supply-gap > (max-capacity-kyushu * fossil-fuel-proportion-kyushu) [
          set electricity-generation max-capacity-kyushu * fossil-fuel-proportion-kyushu
        ] [
          set electricity-generation supply-gap
        ]
      ]
    ]
  ]
end

to calculate-adjusted-supply

 set total-adjusted-supply-hokkaido (sum [electricity-generation] of supplys with [supply-region = "Hokkaido"]) + storage-contribution-hokkaido
  set total-adjusted-supply-tohoku (sum [electricity-generation] of supplys with [supply-region = "Tohoku"]) + storage-contribution-tohoku
  set total-adjusted-supply-tokyo (sum [electricity-generation] of supplys with [supply-region = "Tokyo"]) + storage-contribution-tokyo
  set total-adjusted-supply-chubu (sum [electricity-generation] of supplys with [supply-region = "Chubu"]) + storage-contribution-chubu
  set total-adjusted-supply-hokuriku (sum [electricity-generation] of supplys with [supply-region = "Hokuriku"]) + storage-contribution-hokuriku
  set total-adjusted-supply-kansai (sum [electricity-generation] of supplys with [supply-region = "Kansai"]) + storage-contribution-kansai
  set total-adjusted-supply-chugoku (sum [electricity-generation] of supplys with [supply-region = "Chugoku"]) + storage-contribution-chugoku
  set total-adjusted-supply-shikoku (sum [electricity-generation] of supplys with [supply-region = "Shikoku"]) + storage-contribution-shikoku
  set total-adjusted-supply-kyushu (sum [electricity-generation] of supplys with [supply-region = "Kyushu"]) + storage-contribution-kyushu

end

to balance-electricity
  ask demands [
    set import-amount 0
    set export-amount 0
  ]

  ask demands [
    let regional-total-supply 0
    if demand-region = "Hokkaido" [ set regional-total-supply total-adjusted-supply-hokkaido ]
    if demand-region = "Tohoku" [ set regional-total-supply total-adjusted-supply-tohoku ]
    if demand-region = "Tokyo" [ set regional-total-supply total-adjusted-supply-tokyo ]
    if demand-region = "Chubu" [ set regional-total-supply total-adjusted-supply-chubu ]
    if demand-region = "Hokuriku" [ set regional-total-supply total-adjusted-supply-hokuriku ]
    if demand-region = "Kansai" [ set regional-total-supply total-adjusted-supply-kansai ]
    if demand-region = "Chugoku" [ set regional-total-supply total-adjusted-supply-chugoku ]
    if demand-region = "Shikoku" [ set regional-total-supply total-adjusted-supply-shikoku ]
    if demand-region = "Kyushu" [ set regional-total-supply total-adjusted-supply-kyushu ]

    let supply-gap electricity-demand - regional-total-supply
    if supply-gap < 0 [
      set export-amount supply-gap
    ]
    if supply-gap > 0 [
      set import-amount supply-gap
    ]
  ]

  ask demands with [export-amount > 0] [
    let connections [my-links] of myself
    foreach connections [
      conn ->
      let partner [other-end] of conn
      if [import-amount] of partner > 0 [
        let transfer-amount min (list export-amount [import-amount] of partner [max-transmission-capacity] of conn)
        set export-amount export-amount - transfer-amount
        ask partner [
          set import-amount import-amount - transfer-amount
          set electricity-demand electricity-demand + transfer-amount
        ]
        ask conn [
          set thickness transfer-amount / max-transmission-capacity * 10


          if ([demand-region] of self = "Hokkaido" and [demand-region] of partner = "Tohoku") [
            set hokkaido-tohoku-transport transfer-amount
          ]
          if ([demand-region] of self = "Tohoku" and [demand-region] of partner = "Tokyo") [
            set tohoku-tokyo-transport transfer-amount
          ]
          if ([demand-region] of self = "Tokyo" and [demand-region] of partner = "Chubu") [
            set tokyo-chubu-transport transfer-amount
          ]
          if ([demand-region] of self = "Chubu" and [demand-region] of partner = "Hokuriku") [
            set chubu-hokuriku-transport transfer-amount
          ]
          if ([demand-region] of self = "Kansai" and [demand-region] of partner = "Hokuriku") [
            set kansai-hokuriku-transport transfer-amount
          ]
          if ([demand-region] of self = "Kansai" and [demand-region] of partner = "Chubu") [
            set kansai-chubu-transport transfer-amount
          ]
          if ([demand-region] of self = "Kansai" and [demand-region] of partner = "Chugoku") [
            set kansai-chugoku-transport transfer-amount
          ]
          if ([demand-region] of self = "Kansai" and [demand-region] of partner = "Shikoku") [
            set kansai-shikoku-transport transfer-amount
          ]
          if ([demand-region] of self = "Chugoku" and [demand-region] of partner = "Shikoku") [
            set chugoku-shikoku-transport transfer-amount
          ]
          if ([demand-region] of self = "Chugoku" and [demand-region] of partner = "Kyushu") [
            set chugoku-kyushu-transport transfer-amount
          ]
        ]
      ]
    ]
  ]
end




to smooth-edges
  ask patches [
    if not is-land and all? neighbors [is-land] [
      set pcolor green
      set is-land true
    ]
  ]
end


to-report min-distance-to-land
  report min [distance myself] of patches with [is-land]
end


to plot-graphs
  plot-electricity-generation-by-type
  plot-supply-demand-by-region
  plot-energy-storage-by-region
  plot-supply-deficit-excess
end



to plot-electricity-generation-by-type
  let total-wind-generation sum [electricity-generation] of supplys with [supply-type = "wind"]
  let total-solar-generation sum [electricity-generation] of supplys with [supply-type = "solar"]
  let total-fossil-fuel-generation sum [electricity-generation] of supplys with [supply-type = "fossil-fuel"]
  let total-nuclear-generation sum [electricity-generation] of supplys with [supply-type = "nuclear"]
  let total-hydro-generation sum [electricity-generation] of supplys with [supply-type = "hydro"]
  let total-osw-generation sum [electricity-generation] of supplys with [supply-type = "OSW"]
  let total-other-generation sum [electricity-generation] of supplys with [supply-type = "others"]

  set-current-plot "Electricity Generation by Type"

  set-current-plot-pen "Wind"
  plot total-wind-generation

  set-current-plot-pen "Solar"
  plot total-solar-generation

  set-current-plot-pen "Fossil-Fuel"
  plot total-fossil-fuel-generation

  set-current-plot-pen "Nuclear"
  plot total-nuclear-generation

  set-current-plot-pen "Hydro"
  plot total-hydro-generation

  set-current-plot-pen "OSW"
  plot total-osw-generation

  set-current-plot-pen "Others"
  plot total-other-generation
end


to plot-supply-demand-by-region
  let regions ["Hokkaido" "Tohoku" "Tokyo" "Chubu" "Hokuriku" "Kansai" "Chugoku" "Shikoku" "Kyushu"]

  foreach regions [
    region ->
    set-current-plot region
    let region-supply sum [electricity-generation] of supplys with [supply-region = region]
    let region-demand sum [electricity-demand] of demands with [demand-region = region]

    set-current-plot-pen "Supply"
    plot region-supply

    set-current-plot-pen "Demand"
    plot region-demand
  ]
end

to plot-energy-storage-by-region
  plot-region-storage "Hokkaido"
  plot-region-storage "Tohoku"
  plot-region-storage "Tokyo"
  plot-region-storage "Chubu"
  plot-region-storage "Hokuriku"
  plot-region-storage "Kansai"
  plot-region-storage "Chugoku"
  plot-region-storage "Shikoku"
  plot-region-storage "Kyushu"
end

to plot-region-storage [region]
  set-current-plot (word "Energy Storage " region)
  let region-storage sum [electricity-stored] of storages with [storage-region = region]
  set-current-plot-pen "Storage"
  plot region-storage
end

to plot-supply-deficit-excess
  let totalSupply sum [electricity-generation] of supplys
  let totalDemand sum [electricity-demand] of demands
  let supply-deficit-excess totalSupply - totalDemand

  set-current-plot "Supply Deficit/Excess"

  set-current-plot-pen "Baseline"
  plot 0

  set-current-plot-pen "Deficit/Excess"
  plot supply-deficit-excess
end


@#$#@#$#@
GRAPHICS-WINDOW
898
55
3147
2305
-1
-1
14.94
1
10
1
1
1
0
1
1
1
-75
74
-75
74
0
0
1
ticks
30.0

BUTTON
216
1658
654
1864
NIL
setup
NIL
1
T
OBSERVER
NIL
S
NIL
NIL
1

BUTTON
213
1988
651
2216
NIL
go
T
1
T
OBSERVER
NIL
G
NIL
NIL
1

PLOT
3151
61
4768
1125
Electricity Generation vs Consumption
time
MW
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Demand" 1.0 0 -16777216 true "" "plot total-demand"
"Supply" 1.0 0 -2674135 true "" "plot total-supply"

PLOT
3157
2201
4778
3372
Electricity Generation by Type
time
MW
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Wind" 1.0 0 -7500403 true "" ""
"Solar" 1.0 0 -1184463 true "" ""
"Fossil-Fuel" 1.0 0 -2674135 true "" ""
"Nuclear" 1.0 0 -955883 true "" ""
"Hydro" 1.0 0 -13345367 true "" ""
"OSW" 1.0 0 -11221820 true "" ""
"Others" 1.0 0 -2064490 true "" ""

SLIDER
13
266
243
299
wind-proportion-hokkaido-slider
wind-proportion-hokkaido-slider
0
1
0.1
0.01
1
NIL
HORIZONTAL

SLIDER
13
298
243
331
solar-proportion-hokkaido-slider
solar-proportion-hokkaido-slider
0
1
0.2
0.01
1
NIL
HORIZONTAL

SLIDER
13
331
243
364
OSW-proportion-hokkaido-slider
OSW-proportion-hokkaido-slider
0
1
0.1
0.01
1
NIL
HORIZONTAL

SLIDER
13
366
243
399
hydro-proportion-hokkaido-slider
hydro-proportion-hokkaido-slider
0
1
0.1
0.01
1
NIL
HORIZONTAL

SLIDER
13
398
243
431
others-proportion-hokkaido-slider
others-proportion-hokkaido-slider
0
1
0.1
0.01
1
NIL
HORIZONTAL

SLIDER
13
233
257
266
nuclear-proportion-hokkaido-slider
nuclear-proportion-hokkaido-slider
0
1
0.2
0.01
1
NIL
HORIZONTAL

SLIDER
13
201
257
234
fossil-fuel-proportion-hokkaido-slider
fossil-fuel-proportion-hokkaido-slider
0
1
0.2
0.01
1
NIL
HORIZONTAL

INPUTBOX
11
133
278
193
max-capacity-hokkaido-input
3500.0
1
0
Number

INPUTBOX
288
133
555
193
max-capacity-tohoku-input
11000.0
1
0
Number

INPUTBOX
568
133
835
193
max-capacity-tokyo-input
26000.0
1
0
Number

INPUTBOX
293
623
560
683
max-capacity-chubu-input
15000.0
1
0
Number

INPUTBOX
13
623
280
683
max-capacity-hokuriku-input
3000.0
1
0
Number

INPUTBOX
571
623
837
683
max-capacity-kansai-input
15000.0
1
0
Number

INPUTBOX
291
1116
557
1176
max-capacity-chugoku-input
6000.0
1
0
Number

INPUTBOX
11
1116
279
1176
max-capacity-shikoku-input
5000.0
1
0
Number

INPUTBOX
568
1116
834
1176
max-capacity-kyushu-input
10000.0
1
0
Number

SLIDER
291
201
533
234
fossil-fuel-proportion-tohoku-slider
fossil-fuel-proportion-tohoku-slider
0
1
0.2
0.01
1
NIL
HORIZONTAL

SLIDER
291
233
533
266
nuclear-proportion-tohoku-slider
nuclear-proportion-tohoku-slider
0
1
0.2
0.01
1
NIL
HORIZONTAL

SLIDER
293
268
521
301
wind-proportion-tohoku-slider
wind-proportion-tohoku-slider
0
1
0.1
0.01
1
NIL
HORIZONTAL

SLIDER
293
303
521
336
solar-proportion-tohoku-slider
solar-proportion-tohoku-slider
0
1
0.2
0.01
1
NIL
HORIZONTAL

SLIDER
293
336
521
369
OSW-proportion-tohoku-slider
OSW-proportion-tohoku-slider
0
1
0.1
0.01
1
NIL
HORIZONTAL

SLIDER
293
366
521
399
hydro-proportion-tohoku-slider
hydro-proportion-tohoku-slider
0
1
0.1
0.01
1
NIL
HORIZONTAL

SLIDER
293
401
521
434
others-proportion-tohoku-slider
others-proportion-tohoku-slider
0
1
0.1
0.01
1
NIL
HORIZONTAL

SLIDER
568
201
810
234
fossil-fuel-proportion-tokyo-slider
fossil-fuel-proportion-tokyo-slider
0
1
0.2
0.01
1
NIL
HORIZONTAL

SLIDER
568
233
810
266
nuclear-proportion-tokyo-slider
nuclear-proportion-tokyo-slider
0
1
0.2
0.01
1
NIL
HORIZONTAL

SLIDER
568
266
796
299
wind-proportion-tokyo-slider
wind-proportion-tokyo-slider
0
1
0.1
0.01
1
NIL
HORIZONTAL

SLIDER
568
301
796
334
solar-proportion-tokyo-slider
solar-proportion-tokyo-slider
0
1
0.2
0.01
1
NIL
HORIZONTAL

SLIDER
568
333
796
366
OSW-proportion-tokyo-slider
OSW-proportion-tokyo-slider
0
1
0.1
0.01
1
NIL
HORIZONTAL

SLIDER
568
366
796
399
hydro-proportion-tokyo-slider
hydro-proportion-tokyo-slider
0
1
0.1
0.01
1
NIL
HORIZONTAL

SLIDER
568
401
796
434
others-proportion-tokyo-slider
others-proportion-tokyo-slider
0
1
0.1
0.01
1
NIL
HORIZONTAL

SLIDER
293
691
535
724
fossil-fuel-proportion-chubu-slider
fossil-fuel-proportion-chubu-slider
0
1
0.2
0.01
1
NIL
HORIZONTAL

SLIDER
293
726
535
759
nuclear-proportion-chubu-slider
nuclear-proportion-chubu-slider
0
1
0.2
0.01
1
NIL
HORIZONTAL

SLIDER
293
758
521
791
wind-proportion-chubu-slider
wind-proportion-chubu-slider
0
1
0.1
0.01
1
NIL
HORIZONTAL

SLIDER
293
796
521
829
solar-proportion-chubu-slider
solar-proportion-chubu-slider
0
1
0.2
0.01
1
NIL
HORIZONTAL

SLIDER
293
826
521
859
OSW-proportion-chubu-slider
OSW-proportion-chubu-slider
0
1
0.1
0.01
1
NIL
HORIZONTAL

SLIDER
293
858
521
891
hydro-proportion-chubu-slider
hydro-proportion-chubu-slider
0
1
0.1
0.01
1
NIL
HORIZONTAL

SLIDER
293
896
521
929
others-proportion-chubu-slider
others-proportion-chubu-slider
0
1
0.1
0.01
1
NIL
HORIZONTAL

SLIDER
13
691
255
724
fossil-fuel-proportion-hokuriku-slider
fossil-fuel-proportion-hokuriku-slider
0
1
0.2
0.01
1
NIL
HORIZONTAL

SLIDER
13
726
255
759
nuclear-proportion-hokuriku-slider
nuclear-proportion-hokuriku-slider
0
1
0.2
0.01
1
NIL
HORIZONTAL

SLIDER
13
761
242
794
wind-proportion-hokuriku-slider
wind-proportion-hokuriku-slider
0
1
0.09
0.01
1
NIL
HORIZONTAL

SLIDER
13
793
242
826
solar-proportion-hokuriku-slider
solar-proportion-hokuriku-slider
0
1
0.2
0.01
1
NIL
HORIZONTAL

SLIDER
13
828
242
861
OSW-proportion-hokuriku-slider
OSW-proportion-hokuriku-slider
0
1
0.1
0.01
1
NIL
HORIZONTAL

SLIDER
13
861
242
894
hydro-proportion-hokuriku-slider
hydro-proportion-hokuriku-slider
0
1
0.1
0.01
1
NIL
HORIZONTAL

SLIDER
13
893
242
926
others-proportion-hokuriku-slider
others-proportion-hokuriku-slider
0
1
0.1
0.01
1
NIL
HORIZONTAL

SLIDER
571
691
813
724
fossil-fuel-proportion-kansai-slider
fossil-fuel-proportion-kansai-slider
0
1
0.2
0.01
1
NIL
HORIZONTAL

SLIDER
571
723
813
756
nuclear-proportion-kansai-slider
nuclear-proportion-kansai-slider
0
1
0.2
0.01
1
NIL
HORIZONTAL

SLIDER
571
756
799
789
wind-proportion-kansai-slider
wind-proportion-kansai-slider
0
1
0.1
0.01
1
NIL
HORIZONTAL

SLIDER
571
791
799
824
solar-proportion-kansai-slider
solar-proportion-kansai-slider
0
1
0.2
0.01
1
NIL
HORIZONTAL

SLIDER
571
826
799
859
OSW-proportion-kansai-slider
OSW-proportion-kansai-slider
0
1
0.1
0.01
1
NIL
HORIZONTAL

SLIDER
571
856
799
889
hydro-proportion-kansai-slider
hydro-proportion-kansai-slider
0
1
0.1
0.01
1
NIL
HORIZONTAL

SLIDER
571
893
799
926
others-proportion-kansai-slider
others-proportion-kansai-slider
0
1
0.1
0.01
1
NIL
HORIZONTAL

SLIDER
293
1181
535
1214
fossil-fuel-proportion-chugoku-slider
fossil-fuel-proportion-chugoku-slider
0
1
0.2
0.01
1
NIL
HORIZONTAL

SLIDER
293
1216
535
1249
nuclear-proportion-chugoku-slider
nuclear-proportion-chugoku-slider
0
1
0.2
0.01
1
NIL
HORIZONTAL

SLIDER
293
1251
523
1284
wind-proportion-chugoku-slider
wind-proportion-chugoku-slider
0
1
0.1
0.01
1
NIL
HORIZONTAL

SLIDER
293
1281
523
1314
solar-proportion-chugoku-slider
solar-proportion-chugoku-slider
0
1
0.2
0.01
1
NIL
HORIZONTAL

SLIDER
293
1316
523
1349
OSW-proportion-chugoku-slider
OSW-proportion-chugoku-slider
0
1
0.1
0.01
1
NIL
HORIZONTAL

SLIDER
293
1351
523
1384
hydro-proportion-chugoku-slider
hydro-proportion-chugoku-slider
0
1
0.1
0.01
1
NIL
HORIZONTAL

SLIDER
293
1381
523
1414
others-proportion-chugoku-slider
others-proportion-chugoku-slider
0
1
0.1
0.01
1
NIL
HORIZONTAL

SLIDER
13
1181
255
1214
fossil-fuel-proportion-shikoku-slider
fossil-fuel-proportion-shikoku-slider
0
1
0.2
0.01
1
NIL
HORIZONTAL

SLIDER
13
1216
255
1249
nuclear-proportion-shikoku-slider
nuclear-proportion-shikoku-slider
0
1
0.2
0.01
1
NIL
HORIZONTAL

SLIDER
16
1251
246
1284
wind-proportion-shikoku-slider
wind-proportion-shikoku-slider
0
1
0.1
0.01
1
NIL
HORIZONTAL

SLIDER
16
1281
246
1314
solar-proportion-shikoku-slider
solar-proportion-shikoku-slider
0
1
0.2
0.01
1
NIL
HORIZONTAL

SLIDER
16
1318
246
1351
OSW-proportion-shikoku-slider
OSW-proportion-shikoku-slider
0
1
0.1
0.01
1
NIL
HORIZONTAL

SLIDER
16
1351
246
1384
hydro-proportion-shikoku-slider
hydro-proportion-shikoku-slider
0
1
0.1
0.01
1
NIL
HORIZONTAL

SLIDER
16
1381
246
1414
others-proportion-shikoku-slider
others-proportion-shikoku-slider
0
1
0.1
0.01
1
NIL
HORIZONTAL

SLIDER
571
1181
813
1214
fossil-fuel-proportion-kyushu-slider
fossil-fuel-proportion-kyushu-slider
0
1
0.2
0.01
1
NIL
HORIZONTAL

SLIDER
571
1216
813
1249
nuclear-proportion-kyushu-slider
nuclear-proportion-kyushu-slider
0
1
0.2
0.01
1
NIL
HORIZONTAL

SLIDER
571
1251
801
1284
wind-proportion-kyushu-slider
wind-proportion-kyushu-slider
0
1
0.1
0.01
1
NIL
HORIZONTAL

SLIDER
571
1283
801
1316
solar-proportion-kyushu-slider
solar-proportion-kyushu-slider
0
1
0.2
0.01
1
NIL
HORIZONTAL

SLIDER
571
1316
801
1349
OSW-proportion-kyushu-slider
OSW-proportion-kyushu-slider
0
1
0.1
0.01
1
NIL
HORIZONTAL

SLIDER
571
1348
801
1381
hydro-proportion-kyushu-slider
hydro-proportion-kyushu-slider
0
1
0.1
0.01
1
NIL
HORIZONTAL

SLIDER
571
1381
801
1414
others-proportion-kyushu-slider
others-proportion-kyushu-slider
0
1
0.1
0.01
1
NIL
HORIZONTAL

INPUTBOX
18
446
203
507
storage-capacity-hokkaido-input
5000.0
1
0
Number

INPUTBOX
293
446
478
507
storage-capacity-tohoku-input
12000.0
1
0
Number

INPUTBOX
571
446
746
507
storage-capacity-tokyo-input
32000.0
1
0
Number

INPUTBOX
13
936
198
997
storage-capacity-chubu-input
3000.0
1
0
Number

INPUTBOX
293
936
485
997
storage-capacity-hokuriku-input
15000.0
1
0
Number

INPUTBOX
571
936
753
997
storage-capacity-kansai-input
15000.0
1
0
Number

INPUTBOX
16
1426
208
1487
storage-capacity-chugoku-input
8000.0
1
0
Number

INPUTBOX
293
1421
488
1482
storage-capacity-shikoku-input
6000.0
1
0
Number

INPUTBOX
571
1423
766
1484
storage-capacity-kyushu-input
9000.0
1
0
Number

INPUTBOX
18
506
203
567
storage-max-output-hokkaido-input
1000.0
1
0
Number

INPUTBOX
293
506
478
567
storage-max-output-tohoku-input
3000.0
1
0
Number

INPUTBOX
571
506
746
567
storage-max-output-tokyo-input
8000.0
1
0
Number

INPUTBOX
13
996
198
1057
storage-max-output-chubu-input
1000.0
1
0
Number

INPUTBOX
293
996
485
1057
storage-max-output-hokuriku-input
3000.0
1
0
Number

INPUTBOX
571
996
753
1057
storage-max-output-kansai-input
5000.0
1
0
Number

INPUTBOX
16
1486
208
1547
storage-max-output-chugoku-input
2000.0
1
0
Number

INPUTBOX
293
1481
488
1542
storage-max-output-shikoku-input
2000.0
1
0
Number

INPUTBOX
571
1483
766
1544
storage-max-output-kyushu-input
3000.0
1
0
Number

MONITOR
2516
831
2665
880
Hokkaido <> Tohoku
hokkaido-tohoku-transport
2
1
12

MONITOR
2373
1206
2518
1255
Tohoku <> Tokyo
tohoku-tokyo-transport
2
1
12

MONITOR
2203
1548
2328
1597
Chubu <> Tokyo
tokyo-chubu-transport
2
1
12

MONITOR
2059
1442
2198
1491
Hokuriku <> Chubu
chubu-hokuriku-transport
2
1
12

MONITOR
1832
1430
1968
1479
Kansai <> Hokuriku
kansai-hokuriku-transport
2
1
12

MONITOR
1939
1629
2061
1678
Kansai <> Chubu
kansai-chubu-transport
2
1
12

MONITOR
1650
1508
1788
1557
Chugoku <> Kansai
kansai-chugoku-transport
2
1
12

MONITOR
1722
1706
1852
1755
Shikoku <> Kansai
kansai-shikoku-transport
2
1
12

MONITOR
1546
1673
1694
1722
Chugoku <> Shikoku
chugoku-shikoku-transport
2
1
12

MONITOR
1326
1713
1475
1762
Kyushu <> Chugoku 
chugoku-kyushu-transport
2
1
12

PLOT
0
2356
603
2592
Hokkaido
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
"Supply" 1.0 0 -2674135 true "" ""
"Demand" 1.0 0 -16777216 true "" ""

PLOT
601
2351
1232
2589
Tohoku
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
"Demand" 1.0 0 -16777216 true "" ""
"Supply" 1.0 0 -2674135 true "" ""

PLOT
1231
2356
1867
2594
Tokyo
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
"Demand" 1.0 0 -16777216 true "" ""
"Supply" 1.0 0 -2674135 true "" ""

PLOT
1866
2351
2492
2592
Chubu
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
"Demand" 1.0 0 -16777216 true "" ""
"Supply" 1.0 0 -2674135 true "" ""

PLOT
0
2871
578
3124
Hokuriku
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
"Demand" 1.0 0 -16777216 true "" ""
"Supply" 1.0 0 -2674135 true "" ""

PLOT
2491
2356
3157
2594
Kansai
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
"Demand" 1.0 0 -16777216 true "" ""
"Supply" 1.0 0 -2674135 true "" ""

PLOT
1223
2871
1866
3127
Chugoku
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
"Demand" 1.0 0 -16777216 true "" ""
"Supply" 1.0 0 -2674135 true "" ""

PLOT
578
2871
1224
3124
Shikoku
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
"Demand" 1.0 0 -16777216 true "" ""
"Supply" 1.0 0 -2674135 true "" ""

PLOT
1863
2871
2536
3127
Kyushu
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
"Demand" 1.0 0 -16777216 true "" ""
"Supply" 1.0 0 -2674135 true "" ""

PLOT
0
2588
601
2811
Energy Storage Hokkaido
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
"Storage" 1.0 0 -13791810 true "" ""

PLOT
598
2593
1229
2809
Energy Storage Tohoku
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
"Storage" 1.0 0 -13791810 true "" ""

PLOT
1228
2593
1864
2806
Energy Storage Tokyo
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
"Storage" 1.0 0 -13791810 true "" ""

PLOT
1863
2591
2489
2807
Energy Storage Chubu
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
"Storage" 1.0 0 -13791810 true "" ""

PLOT
2488
2588
3159
2809
Energy Storage Kansai
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
"Storage" 1.0 0 -13791810 true "" ""

PLOT
0
3123
576
3341
Energy Storage Hokuriku
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
"Storage" 1.0 0 -13791810 true "" ""

PLOT
576
3121
1229
3344
Energy Storage Shikoku
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
"Storage" 1.0 0 -13791810 true "" ""

PLOT
1226
3123
1867
3344
Energy Storage Chugoku
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
"Storage" 1.0 0 -13791810 true "" ""

PLOT
1863
3123
2539
3341
Energy Storage Kyushu
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
"Storage" 1.0 0 -13791810 true "" ""

PLOT
3154
1127
4778
2201
Supply Deficit/Excess
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
"Baseline" 1.0 0 -16777216 true "" ""
"Deficit/Excess" 1.0 0 -8630108 true "" ""

@#$#@#$#@
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
NetLogo 6.4.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
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
