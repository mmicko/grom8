{
  "version": "1.1",
  "package": {
    "name": "Grom-8",
    "version": "1.0",
    "description": "Grom-8 CPU",
    "author": "Miodrag Milanovic",
    "image": ""
  },
  "design": {
    "board": "go-board",
    "graph": {
      "blocks": [
        {
          "id": "bdb8d2d8-7cef-4b5f-b70d-2e12d75d6818",
          "type": "basic.input",
          "data": {
            "name": "RESET",
            "pins": [
              {
                "index": "0",
                "name": "SW1",
                "value": "53"
              }
            ],
            "virtual": false,
            "clock": false
          },
          "position": {
            "x": -24,
            "y": -80
          }
        },
        {
          "id": "6f8327c5-f293-4e30-b5ae-624e40c04225",
          "type": "basic.output",
          "data": {
            "name": "HALTLED",
            "pins": [
              {
                "index": "0",
                "name": "LED1",
                "value": "56"
              }
            ],
            "virtual": false
          },
          "position": {
            "x": 336,
            "y": 64
          }
        },
        {
          "id": "5e7621b5-809d-4478-9b4e-65071a6c8daa",
          "type": "basic.output",
          "data": {
            "name": "S1",
            "range": "[6:0]",
            "pins": [
              {
                "index": "6",
                "name": "S1_A",
                "value": "3"
              },
              {
                "index": "5",
                "name": "S1_B",
                "value": "4"
              },
              {
                "index": "4",
                "name": "S1_C",
                "value": "93"
              },
              {
                "index": "3",
                "name": "S1_D",
                "value": "91"
              },
              {
                "index": "2",
                "name": "S1_E",
                "value": "90"
              },
              {
                "index": "1",
                "name": "S1_F",
                "value": "1"
              },
              {
                "index": "0",
                "name": "S1_G",
                "value": "2"
              }
            ],
            "virtual": false
          },
          "position": {
            "x": 1680,
            "y": 80
          }
        },
        {
          "id": "021cb0ba-e841-4d9a-bc44-67810b81d710",
          "type": "basic.output",
          "data": {
            "name": "S2",
            "range": "[6:0]",
            "pins": [
              {
                "index": "6",
                "name": "S2_A",
                "value": "100"
              },
              {
                "index": "5",
                "name": "S2_B",
                "value": "99"
              },
              {
                "index": "4",
                "name": "S2_C",
                "value": "97"
              },
              {
                "index": "3",
                "name": "S2_D",
                "value": "95"
              },
              {
                "index": "2",
                "name": "S2_E",
                "value": "94"
              },
              {
                "index": "1",
                "name": "S2_F",
                "value": "8"
              },
              {
                "index": "0",
                "name": "S2_G",
                "value": "96"
              }
            ],
            "virtual": false
          },
          "position": {
            "x": 1680,
            "y": 360
          }
        },
        {
          "id": "1d9f62e8-b997-4346-8e61-eba916c67862",
          "type": "basic.code",
          "data": {
            "code": " reg [7:0] display_out = 8'h12;\r\n \r\n always @(posedge clk)\r\n\tbegin\r\n\t\tif(ioreq==1 && we==1)\r\n\t\tbegin\r\n\t\t\tdisplay_out <= data_in;\r\n\t\tend\r\n\tend",
            "params": [],
            "ports": {
              "in": [
                {
                  "name": "clk"
                },
                {
                  "name": "ioreq"
                },
                {
                  "name": "we"
                },
                {
                  "name": "data_in",
                  "range": "[7:0]",
                  "size": 8
                }
              ],
              "out": [
                {
                  "name": "display_out",
                  "range": "[7:0]",
                  "size": 8
                }
              ]
            }
          },
          "position": {
            "x": 592,
            "y": 264
          },
          "size": {
            "width": 400,
            "height": 176
          }
        },
        {
          "id": "f8016266-b629-4008-b686-0fe84a768cf5",
          "type": "basic.code",
          "data": {
            "code": "reg [7:0] data_out;\r\nreg [7:0] store[0:4095];\r\n\r\ninitial\r\nbegin\r\n    store[0] <= 8'b11100001; // MOV DS,2\r\n    store[1] <= 8'b00000010; //\r\n    store[2] <= 8'b01010100; // LOAD R1,[R0]\r\n    store[3] <= 8'b00110001; // INC R1\r\n    store[4] <= 8'b00110001; // INC R1\r\n    store[5] <= 8'b01100001; // STORE [R0],R1\r\n    store[6] <= 8'b11010001; // OUT [0],R1\r\n    store[7] <= 8'b00000000; //\r\n    store[8] <= 8'b01111111; // HLT\r\nend\r\n\r\nalways @(posedge clk)\r\nif (we)\r\n  store[addr] <= data_in;\r\nelse\r\n  data_out <= store[addr];",
            "params": [],
            "ports": {
              "in": [
                {
                  "name": "clk"
                },
                {
                  "name": "addr",
                  "range": "[11:0]",
                  "size": 12
                },
                {
                  "name": "data_in",
                  "range": "[7:0]",
                  "size": 8
                },
                {
                  "name": "we"
                }
              ],
              "out": [
                {
                  "name": "data_out",
                  "range": "[7:0]",
                  "size": 8
                }
              ]
            }
          },
          "position": {
            "x": 1136,
            "y": -208
          },
          "size": {
            "width": 464,
            "height": 352
          }
        },
        {
          "id": "b511a537-abcf-4dd2-9c5e-ad3844607914",
          "type": "32200dc0915d45d6ec035bcec61c8472f0cc7b88",
          "position": {
            "x": 664,
            "y": 24
          },
          "size": {
            "width": 96,
            "height": 64
          }
        },
        {
          "id": "05a21837-18d6-40bb-8a04-30c0da0a2f97",
          "type": "11a6f454705778e2f00adba4e5b28dcd9411bc8f",
          "position": {
            "x": 840,
            "y": 8
          },
          "size": {
            "width": 96,
            "height": 64
          }
        },
        {
          "id": "4052d141-b548-4386-bf3e-5bdb814da8f8",
          "type": "f74ad96c4881fd66d8a66099b6a383f13790bde7",
          "position": {
            "x": 1240,
            "y": 304
          },
          "size": {
            "width": 96,
            "height": 64
          }
        },
        {
          "id": "61c26392-d6cc-4b30-b48e-038ea0413bb9",
          "type": "58213494ca3694cf7d54a3aa8ef34196dc2fa7a9",
          "position": {
            "x": 192,
            "y": -128
          },
          "size": {
            "width": 96,
            "height": 160
          }
        }
      ],
      "wires": [
        {
          "source": {
            "block": "05a21837-18d6-40bb-8a04-30c0da0a2f97",
            "port": "664caf9e-5f40-4df4-800a-b626af702e62"
          },
          "target": {
            "block": "f8016266-b629-4008-b686-0fe84a768cf5",
            "port": "we"
          },
          "vertices": [
            {
              "x": 1000,
              "y": 48
            }
          ]
        },
        {
          "source": {
            "block": "b511a537-abcf-4dd2-9c5e-ad3844607914",
            "port": "664caf9e-5f40-4df4-800a-b626af702e62"
          },
          "target": {
            "block": "05a21837-18d6-40bb-8a04-30c0da0a2f97",
            "port": "97b51945-d716-4b6c-9db9-970d08541249"
          }
        },
        {
          "source": {
            "block": "1d9f62e8-b997-4346-8e61-eba916c67862",
            "port": "display_out"
          },
          "target": {
            "block": "4052d141-b548-4386-bf3e-5bdb814da8f8",
            "port": "d3746d71-9a02-4b67-8de3-1e6db572a1b6"
          },
          "size": 8
        },
        {
          "source": {
            "block": "4052d141-b548-4386-bf3e-5bdb814da8f8",
            "port": "a214789b-db10-4525-ba80-20c320c62a32"
          },
          "target": {
            "block": "5e7621b5-809d-4478-9b4e-65071a6c8daa",
            "port": "in"
          },
          "size": 7
        },
        {
          "source": {
            "block": "4052d141-b548-4386-bf3e-5bdb814da8f8",
            "port": "0a33152f-2efc-4333-a306-35ed1b32b5c9"
          },
          "target": {
            "block": "021cb0ba-e841-4d9a-bc44-67810b81d710",
            "port": "in"
          },
          "size": 7
        },
        {
          "source": {
            "block": "bdb8d2d8-7cef-4b5f-b70d-2e12d75d6818",
            "port": "out"
          },
          "target": {
            "block": "61c26392-d6cc-4b30-b48e-038ea0413bb9",
            "port": "7137e9cd-16ae-4d4e-96e9-39ee108889b0"
          }
        },
        {
          "source": {
            "block": "61c26392-d6cc-4b30-b48e-038ea0413bb9",
            "port": "ef426d56-bc16-4230-a54f-cc61ac61cfb5"
          },
          "target": {
            "block": "b511a537-abcf-4dd2-9c5e-ad3844607914",
            "port": "18c2ebc7-5152-439c-9b3f-851c59bac834"
          }
        },
        {
          "source": {
            "block": "61c26392-d6cc-4b30-b48e-038ea0413bb9",
            "port": "cc25dd56-f44c-4ae1-abd5-20df6f53ff18"
          },
          "target": {
            "block": "05a21837-18d6-40bb-8a04-30c0da0a2f97",
            "port": "18c2ebc7-5152-439c-9b3f-851c59bac834"
          }
        },
        {
          "source": {
            "block": "61c26392-d6cc-4b30-b48e-038ea0413bb9",
            "port": "cc25dd56-f44c-4ae1-abd5-20df6f53ff18"
          },
          "target": {
            "block": "1d9f62e8-b997-4346-8e61-eba916c67862",
            "port": "we"
          },
          "vertices": [
            {
              "x": 480,
              "y": 168
            }
          ]
        },
        {
          "source": {
            "block": "61c26392-d6cc-4b30-b48e-038ea0413bb9",
            "port": "2ccf9cd7-4d75-49e7-bafb-0fb3522d58a0"
          },
          "target": {
            "block": "6f8327c5-f293-4e30-b5ae-624e40c04225",
            "port": "in"
          }
        },
        {
          "source": {
            "block": "61c26392-d6cc-4b30-b48e-038ea0413bb9",
            "port": "ef426d56-bc16-4230-a54f-cc61ac61cfb5"
          },
          "target": {
            "block": "1d9f62e8-b997-4346-8e61-eba916c67862",
            "port": "ioreq"
          },
          "vertices": [
            {
              "x": 520,
              "y": 208
            }
          ]
        },
        {
          "source": {
            "block": "61c26392-d6cc-4b30-b48e-038ea0413bb9",
            "port": "60084d58-17f4-4238-a8eb-1b3dc4f1bb84"
          },
          "target": {
            "block": "f8016266-b629-4008-b686-0fe84a768cf5",
            "port": "addr"
          },
          "vertices": [
            {
              "x": 1048,
              "y": -72
            }
          ],
          "size": 12
        },
        {
          "source": {
            "block": "61c26392-d6cc-4b30-b48e-038ea0413bb9",
            "port": "612403e6-8ef2-4c0e-84a0-875ff8805a03"
          },
          "target": {
            "block": "f8016266-b629-4008-b686-0fe84a768cf5",
            "port": "data_in"
          },
          "vertices": [
            {
              "x": 1000,
              "y": -32
            }
          ],
          "size": 8
        },
        {
          "source": {
            "block": "f8016266-b629-4008-b686-0fe84a768cf5",
            "port": "data_out"
          },
          "target": {
            "block": "61c26392-d6cc-4b30-b48e-038ea0413bb9",
            "port": "0a1ce504-dd8a-48e0-98c5-05df511d2fcb"
          },
          "vertices": [
            {
              "x": 104,
              "y": -248
            }
          ],
          "size": 8
        },
        {
          "source": {
            "block": "61c26392-d6cc-4b30-b48e-038ea0413bb9",
            "port": "612403e6-8ef2-4c0e-84a0-875ff8805a03"
          },
          "target": {
            "block": "1d9f62e8-b997-4346-8e61-eba916c67862",
            "port": "data_in"
          },
          "vertices": [
            {
              "x": 448,
              "y": 176
            }
          ],
          "size": 8
        }
      ]
    },
    "state": {
      "pan": {
        "x": 186.3237,
        "y": 307.3236
      },
      "zoom": 0.9627
    }
  },
  "dependencies": {
    "32200dc0915d45d6ec035bcec61c8472f0cc7b88": {
      "package": {
        "name": "NOT",
        "version": "1.0.0",
        "description": "NOT logic gate",
        "author": "Jesús Arroyo",
        "image": "%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20width=%2291.33%22%20height=%2245.752%22%20version=%221%22%3E%3Cpath%20d=%22M0%2020.446h27v2H0zM70.322%2020.447h15.3v2h-15.3z%22/%3E%3Cpath%20d=%22M66.05%2026.746c-2.9%200-5.3-2.4-5.3-5.3s2.4-5.3%205.3-5.3%205.3%202.4%205.3%205.3-2.4%205.3-5.3%205.3zm0-8.6c-1.8%200-3.3%201.5-3.3%203.3%200%201.8%201.5%203.3%203.3%203.3%201.8%200%203.3-1.5%203.3-3.3%200-1.8-1.5-3.3-3.3-3.3z%22/%3E%3Cpath%20d=%22M25.962%202.563l33.624%2018.883L25.962%2040.33V2.563z%22%20fill=%22none%22%20stroke=%22#000%22%20stroke-width=%223%22/%3E%3C/svg%3E"
      },
      "design": {
        "graph": {
          "blocks": [
            {
              "id": "5365ed8c-e5db-4445-938f-8d689830ea5c",
              "type": "basic.code",
              "data": {
                "code": "// NOT logic gate\n\nassign c = ~ a;",
                "params": [],
                "ports": {
                  "in": [
                    {
                      "name": "a"
                    }
                  ],
                  "out": [
                    {
                      "name": "c"
                    }
                  ]
                }
              },
              "position": {
                "x": 256,
                "y": 48
              }
            },
            {
              "id": "18c2ebc7-5152-439c-9b3f-851c59bac834",
              "type": "basic.input",
              "data": {
                "name": ""
              },
              "position": {
                "x": 64,
                "y": 144
              }
            },
            {
              "id": "664caf9e-5f40-4df4-800a-b626af702e62",
              "type": "basic.output",
              "data": {
                "name": ""
              },
              "position": {
                "x": 752,
                "y": 144
              }
            }
          ],
          "wires": [
            {
              "source": {
                "block": "18c2ebc7-5152-439c-9b3f-851c59bac834",
                "port": "out"
              },
              "target": {
                "block": "5365ed8c-e5db-4445-938f-8d689830ea5c",
                "port": "a"
              }
            },
            {
              "source": {
                "block": "5365ed8c-e5db-4445-938f-8d689830ea5c",
                "port": "c"
              },
              "target": {
                "block": "664caf9e-5f40-4df4-800a-b626af702e62",
                "port": "in"
              }
            }
          ]
        },
        "state": {
          "pan": {
            "x": 0,
            "y": 0
          },
          "zoom": 1
        }
      }
    },
    "11a6f454705778e2f00adba4e5b28dcd9411bc8f": {
      "package": {
        "name": "AND",
        "version": "1.0.0",
        "description": "AND logic gate",
        "author": "Jesús Arroyo",
        "image": "%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%22-252%20400.9%2090%2040%22%3E%3Cpath%20d=%22M-252%20409.9h26v2h-26zM-252%20429.9h27v2h-27z%22/%3E%3Cpath%20d=%22M-227%20400.9v39.9h20.4c11.3%200%2020-9%2020-20s-8.7-20-20-20H-227zm2.9%202.8h17.6c9.8%200%2016.7%207.6%2016.7%2017.1%200%209.5-7.4%2017.1-17.1%2017.1H-224c-.1.1-.1-34.2-.1-34.2z%22/%3E%3Cpath%20d=%22M-187.911%20419.9H-162v2h-25.911z%22/%3E%3C/svg%3E"
      },
      "design": {
        "graph": {
          "blocks": [
            {
              "id": "00925b04-5004-4307-a737-fa4e97c8b6ab",
              "type": "basic.code",
              "data": {
                "code": "// AND logic gate\n\nassign c = a & b;",
                "params": [],
                "ports": {
                  "in": [
                    {
                      "name": "a"
                    },
                    {
                      "name": "b"
                    }
                  ],
                  "out": [
                    {
                      "name": "c"
                    }
                  ]
                }
              },
              "position": {
                "x": 256,
                "y": 48
              }
            },
            {
              "id": "18c2ebc7-5152-439c-9b3f-851c59bac834",
              "type": "basic.input",
              "data": {
                "name": ""
              },
              "position": {
                "x": 64,
                "y": 80
              }
            },
            {
              "id": "664caf9e-5f40-4df4-800a-b626af702e62",
              "type": "basic.output",
              "data": {
                "name": ""
              },
              "position": {
                "x": 752,
                "y": 144
              }
            },
            {
              "id": "97b51945-d716-4b6c-9db9-970d08541249",
              "type": "basic.input",
              "data": {
                "name": ""
              },
              "position": {
                "x": 64,
                "y": 208
              }
            }
          ],
          "wires": [
            {
              "source": {
                "block": "18c2ebc7-5152-439c-9b3f-851c59bac834",
                "port": "out"
              },
              "target": {
                "block": "00925b04-5004-4307-a737-fa4e97c8b6ab",
                "port": "a"
              }
            },
            {
              "source": {
                "block": "97b51945-d716-4b6c-9db9-970d08541249",
                "port": "out"
              },
              "target": {
                "block": "00925b04-5004-4307-a737-fa4e97c8b6ab",
                "port": "b"
              }
            },
            {
              "source": {
                "block": "00925b04-5004-4307-a737-fa4e97c8b6ab",
                "port": "c"
              },
              "target": {
                "block": "664caf9e-5f40-4df4-800a-b626af702e62",
                "port": "in"
              }
            }
          ]
        },
        "state": {
          "pan": {
            "x": 0,
            "y": 0
          },
          "zoom": 1
        }
      }
    },
    "f74ad96c4881fd66d8a66099b6a383f13790bde7": {
      "package": {
        "name": "HEX to 2 x 7seg",
        "version": "1.0",
        "description": "8-bit value to two 7seg displays",
        "author": "Miodrag Milanovic",
        "image": "%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20width=%22898.3%22%20height=%22898.3%22%20viewBox=%220%200%20898.3%20898.3%22%3E%3Cpath%20d=%22M120.2%20882.5l433.4-433.3L120.2%2015.8%200%20136l313.2%20313.2L0%20762.3z%22/%3E%3Cpath%20d=%22M344.7%20762.3l120.2%20120.2%20433.4-433.3L464.9%2015.8%20344.7%20136l313.2%20313.2z%22/%3E%3C/svg%3E"
      },
      "design": {
        "graph": {
          "blocks": [
            {
              "id": "a214789b-db10-4525-ba80-20c320c62a32",
              "type": "basic.output",
              "data": {
                "name": "Segment1",
                "range": "[6:0]",
                "size": 7
              },
              "position": {
                "x": 808,
                "y": 136
              }
            },
            {
              "id": "129a3e9c-cee8-4e02-9114-a44a9515fbef",
              "type": "basic.input",
              "data": {
                "name": "clk",
                "clock": true
              },
              "position": {
                "x": 128,
                "y": 136
              }
            },
            {
              "id": "d3746d71-9a02-4b67-8de3-1e6db572a1b6",
              "type": "basic.input",
              "data": {
                "name": "input_value",
                "range": "[7:0]",
                "clock": false,
                "size": 8
              },
              "position": {
                "x": 128,
                "y": 328
              }
            },
            {
              "id": "0a33152f-2efc-4333-a306-35ed1b32b5c9",
              "type": "basic.output",
              "data": {
                "name": "Segment2",
                "range": "[6:0]",
                "size": 7
              },
              "position": {
                "x": 808,
                "y": 328
              }
            },
            {
              "id": "540818d8-c478-45b8-b5af-0fa3f2832ded",
              "type": "basic.code",
              "data": {
                "code": "// @include hex_to_7seg.v\r\n\r\n hex_to_7seg upper_digit\r\n  (.i_Clk(clk),\r\n   .i_Value(data_input[7:4]),\r\n   .o_Segment_A(S1[6]),\r\n   .o_Segment_B(S1[5]),\r\n   .o_Segment_C(S1[4]),\r\n   .o_Segment_D(S1[3]),\r\n   .o_Segment_E(S1[2]),\r\n   .o_Segment_F(S1[1]),\r\n   .o_Segment_G(S1[0]));\r\n\r\n  hex_to_7seg lower_digit\r\n  (.i_Clk(clk),\r\n   .i_Value(data_input[3:0]),\r\n   .o_Segment_A(S2[6]),\r\n   .o_Segment_B(S2[5]),\r\n   .o_Segment_C(S2[4]),\r\n   .o_Segment_D(S2[3]),\r\n   .o_Segment_E(S2[2]),\r\n   .o_Segment_F(S2[1]),\r\n   .o_Segment_G(S2[0]));\r\n",
                "params": [],
                "ports": {
                  "in": [
                    {
                      "name": "clk"
                    },
                    {
                      "name": "data_input",
                      "range": "[7:0]",
                      "size": 8
                    }
                  ],
                  "out": [
                    {
                      "name": "S1",
                      "range": "[6:0]",
                      "size": 7
                    },
                    {
                      "name": "S2",
                      "range": "[6:0]",
                      "size": 7
                    }
                  ]
                }
              },
              "position": {
                "x": 376,
                "y": 72
              },
              "size": {
                "width": 352,
                "height": 384
              }
            }
          ],
          "wires": [
            {
              "source": {
                "block": "d3746d71-9a02-4b67-8de3-1e6db572a1b6",
                "port": "out"
              },
              "target": {
                "block": "540818d8-c478-45b8-b5af-0fa3f2832ded",
                "port": "data_input"
              },
              "size": 8
            },
            {
              "source": {
                "block": "540818d8-c478-45b8-b5af-0fa3f2832ded",
                "port": "S1"
              },
              "target": {
                "block": "a214789b-db10-4525-ba80-20c320c62a32",
                "port": "in"
              },
              "size": 7
            },
            {
              "source": {
                "block": "540818d8-c478-45b8-b5af-0fa3f2832ded",
                "port": "S2"
              },
              "target": {
                "block": "0a33152f-2efc-4333-a306-35ed1b32b5c9",
                "port": "in"
              },
              "size": 7
            },
            {
              "source": {
                "block": "129a3e9c-cee8-4e02-9114-a44a9515fbef",
                "port": "out"
              },
              "target": {
                "block": "540818d8-c478-45b8-b5af-0fa3f2832ded",
                "port": "clk"
              }
            }
          ]
        },
        "state": {
          "pan": {
            "x": -58,
            "y": 19
          },
          "zoom": 1
        }
      }
    },
    "58213494ca3694cf7d54a3aa8ef34196dc2fa7a9": {
      "package": {
        "name": "Grom-8 CPU",
        "version": "1.0",
        "description": "Grom-8 CPU Core",
        "author": "Miodrag Milanovic",
        "image": "%3Csvg%20height=%22512%22%20viewBox=%220%200%20512%20512%22%20width=%22512%22%20xmlns=%22http://www.w3.org/2000/svg%22%3E%3Cpath%20d=%22M199%20387h-62.218c-.221%200%20.221%200%200%200C91.805%20387%2056%20350.337%2056%20305.36c0-44.977%2036.456-81.537%2081.433-81.537%203.922%200%207.778.222%2011.557.769%2013.941-56.938%2065.316-99.218%20126.554-99.218%2071.961%200%20130.293%2058.319%20130.293%20130.28%200%2010.593-1.264%2020.879-3.661%2030.743%201.212-.091%202.423-.03%203.661-.03%2027.7%200%2050.163%2022.563%2050.163%2050.263S433.537%20387%20405.837%20387H338%22%20fill=%22none%22%20stroke=%22#000%22%20stroke-miterlimit=%2210%22%20stroke-width=%2230%22/%3E%3Cpath%20stroke=%22#000%22%20stroke-linecap=%22round%22%20stroke-miterlimit=%2210%22%20stroke-width=%224%22%20d=%22M286.705%20270.678l-71.022%20100.615%2059.185%2026.633-38.47%2088.53%2082.858-97.408-62.144-35.511z%22/%3E%3C/svg%3E"
      },
      "design": {
        "graph": {
          "blocks": [
            {
              "id": "60084d58-17f4-4238-a8eb-1b3dc4f1bb84",
              "type": "basic.output",
              "data": {
                "name": "addr",
                "range": "[11:0]",
                "size": 12
              },
              "position": {
                "x": 856,
                "y": 160
              }
            },
            {
              "id": "d8aa167e-2d9b-4926-bc59-89564fcb5c02",
              "type": "basic.input",
              "data": {
                "name": "clk",
                "clock": true
              },
              "position": {
                "x": 280,
                "y": 192
              }
            },
            {
              "id": "612403e6-8ef2-4c0e-84a0-875ff8805a03",
              "type": "basic.output",
              "data": {
                "name": "data_out",
                "range": "[7:0]",
                "size": 8
              },
              "position": {
                "x": 856,
                "y": 248
              }
            },
            {
              "id": "7137e9cd-16ae-4d4e-96e9-39ee108889b0",
              "type": "basic.input",
              "data": {
                "name": "reset",
                "clock": false
              },
              "position": {
                "x": 280,
                "y": 328
              }
            },
            {
              "id": "cc25dd56-f44c-4ae1-abd5-20df6f53ff18",
              "type": "basic.output",
              "data": {
                "name": "we"
              },
              "position": {
                "x": 856,
                "y": 328
              }
            },
            {
              "id": "ef426d56-bc16-4230-a54f-cc61ac61cfb5",
              "type": "basic.output",
              "data": {
                "name": "ioreq"
              },
              "position": {
                "x": 856,
                "y": 408
              }
            },
            {
              "id": "0a1ce504-dd8a-48e0-98c5-05df511d2fcb",
              "type": "basic.input",
              "data": {
                "name": "data_in",
                "range": "[7:0]",
                "clock": false,
                "size": 8
              },
              "position": {
                "x": 280,
                "y": 464
              }
            },
            {
              "id": "2ccf9cd7-4d75-49e7-bafb-0fb3522d58a0",
              "type": "basic.output",
              "data": {
                "name": "hlt"
              },
              "position": {
                "x": 856,
                "y": 496
              }
            },
            {
              "id": "aa6c8682-fe13-4a26-aa83-fde87ccd2238",
              "type": "basic.code",
              "data": {
                "code": "// @include grom_cpu.v\n// @include alu.v\n\ngrom_cpu cpu(\n\t.clk(clk),\n\t.reset(reset),\n\t.addr(addr),\n\t.data_in(data_in),\n\t.data_out(data_out),\n\t.we(we),\n\t.ioreq(ioreq),\n\t.hlt(hlt)\n);\n",
                "params": [],
                "ports": {
                  "in": [
                    {
                      "name": "clk"
                    },
                    {
                      "name": "reset"
                    },
                    {
                      "name": "data_in",
                      "range": "[7:0]",
                      "size": 8
                    }
                  ],
                  "out": [
                    {
                      "name": "addr",
                      "range": "[11:0]",
                      "size": 12
                    },
                    {
                      "name": "data_out",
                      "range": "[7:0]",
                      "size": 8
                    },
                    {
                      "name": "we"
                    },
                    {
                      "name": "ioreq"
                    },
                    {
                      "name": "hlt"
                    }
                  ]
                }
              },
              "position": {
                "x": 480,
                "y": 152
              },
              "size": {
                "width": 288,
                "height": 416
              }
            }
          ],
          "wires": [
            {
              "source": {
                "block": "7137e9cd-16ae-4d4e-96e9-39ee108889b0",
                "port": "out"
              },
              "target": {
                "block": "aa6c8682-fe13-4a26-aa83-fde87ccd2238",
                "port": "reset"
              }
            },
            {
              "source": {
                "block": "0a1ce504-dd8a-48e0-98c5-05df511d2fcb",
                "port": "out"
              },
              "target": {
                "block": "aa6c8682-fe13-4a26-aa83-fde87ccd2238",
                "port": "data_in"
              },
              "size": 8
            },
            {
              "source": {
                "block": "aa6c8682-fe13-4a26-aa83-fde87ccd2238",
                "port": "addr"
              },
              "target": {
                "block": "60084d58-17f4-4238-a8eb-1b3dc4f1bb84",
                "port": "in"
              },
              "size": 12
            },
            {
              "source": {
                "block": "aa6c8682-fe13-4a26-aa83-fde87ccd2238",
                "port": "data_out"
              },
              "target": {
                "block": "612403e6-8ef2-4c0e-84a0-875ff8805a03",
                "port": "in"
              },
              "size": 8
            },
            {
              "source": {
                "block": "aa6c8682-fe13-4a26-aa83-fde87ccd2238",
                "port": "we"
              },
              "target": {
                "block": "cc25dd56-f44c-4ae1-abd5-20df6f53ff18",
                "port": "in"
              }
            },
            {
              "source": {
                "block": "aa6c8682-fe13-4a26-aa83-fde87ccd2238",
                "port": "ioreq"
              },
              "target": {
                "block": "ef426d56-bc16-4230-a54f-cc61ac61cfb5",
                "port": "in"
              }
            },
            {
              "source": {
                "block": "aa6c8682-fe13-4a26-aa83-fde87ccd2238",
                "port": "hlt"
              },
              "target": {
                "block": "2ccf9cd7-4d75-49e7-bafb-0fb3522d58a0",
                "port": "in"
              }
            },
            {
              "source": {
                "block": "d8aa167e-2d9b-4926-bc59-89564fcb5c02",
                "port": "out"
              },
              "target": {
                "block": "aa6c8682-fe13-4a26-aa83-fde87ccd2238",
                "port": "clk"
              }
            }
          ]
        },
        "state": {
          "pan": {
            "x": -158,
            "y": -77
          },
          "zoom": 1
        }
      }
    }
  }
}