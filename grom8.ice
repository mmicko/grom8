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
            "x": -152,
            "y": 72
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
            "x": 176,
            "y": 368
          }
        },
        {
          "id": "a1a43b56-ef28-4c6a-a7f7-bdb47cd1f373",
          "type": "basic.code",
          "data": {
            "code": "assign mem_enable = we & ~ioreq;",
            "params": [],
            "ports": {
              "in": [
                {
                  "name": "we"
                },
                {
                  "name": "ioreq"
                }
              ],
              "out": [
                {
                  "name": "mem_enable"
                }
              ]
            }
          },
          "position": {
            "x": 592,
            "y": 88
          },
          "size": {
            "width": 352,
            "height": 48
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
            "x": 1104,
            "y": -200
          },
          "size": {
            "width": 464,
            "height": 352
          }
        },
        {
          "id": "7902cb01-e753-42af-8f22-29dd42060d04",
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
            "x": 88,
            "y": -104
          },
          "size": {
            "width": 288,
            "height": 416
          }
        },
        {
          "id": "62d16b57-035c-4a86-b00d-7a19de9561c7",
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
            "x": 1216,
            "y": 200
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
            "block": "7902cb01-e753-42af-8f22-29dd42060d04",
            "port": "ioreq"
          },
          "target": {
            "block": "1d9f62e8-b997-4346-8e61-eba916c67862",
            "port": "ioreq"
          },
          "vertices": [
            {
              "x": 512,
              "y": 272
            }
          ]
        },
        {
          "source": {
            "block": "a1a43b56-ef28-4c6a-a7f7-bdb47cd1f373",
            "port": "mem_enable"
          },
          "target": {
            "block": "f8016266-b629-4008-b686-0fe84a768cf5",
            "port": "we"
          }
        },
        {
          "source": {
            "block": "7902cb01-e753-42af-8f22-29dd42060d04",
            "port": "we"
          },
          "target": {
            "block": "1d9f62e8-b997-4346-8e61-eba916c67862",
            "port": "we"
          },
          "vertices": [
            {
              "x": 472,
              "y": 336
            }
          ]
        },
        {
          "source": {
            "block": "7902cb01-e753-42af-8f22-29dd42060d04",
            "port": "hlt"
          },
          "target": {
            "block": "6f8327c5-f293-4e30-b5ae-624e40c04225",
            "port": "in"
          },
          "vertices": [
            {
              "x": 160,
              "y": 344
            }
          ]
        },
        {
          "source": {
            "block": "f8016266-b629-4008-b686-0fe84a768cf5",
            "port": "data_out"
          },
          "target": {
            "block": "7902cb01-e753-42af-8f22-29dd42060d04",
            "port": "data_in"
          },
          "vertices": [
            {
              "x": 1680,
              "y": -224
            },
            {
              "x": -8,
              "y": -232
            }
          ],
          "size": 8
        },
        {
          "source": {
            "block": "7902cb01-e753-42af-8f22-29dd42060d04",
            "port": "addr"
          },
          "target": {
            "block": "f8016266-b629-4008-b686-0fe84a768cf5",
            "port": "addr"
          },
          "vertices": [],
          "size": 12
        },
        {
          "source": {
            "block": "1d9f62e8-b997-4346-8e61-eba916c67862",
            "port": "display_out"
          },
          "target": {
            "block": "62d16b57-035c-4a86-b00d-7a19de9561c7",
            "port": "data_input"
          },
          "vertices": [
            {
              "x": 1104,
              "y": 416
            }
          ],
          "size": 8
        },
        {
          "source": {
            "block": "7902cb01-e753-42af-8f22-29dd42060d04",
            "port": "data_out"
          },
          "target": {
            "block": "1d9f62e8-b997-4346-8e61-eba916c67862",
            "port": "data_in"
          },
          "vertices": [
            {
              "x": 432,
              "y": 288
            }
          ],
          "size": 8
        },
        {
          "source": {
            "block": "bdb8d2d8-7cef-4b5f-b70d-2e12d75d6818",
            "port": "out"
          },
          "target": {
            "block": "7902cb01-e753-42af-8f22-29dd42060d04",
            "port": "reset"
          }
        },
        {
          "source": {
            "block": "7902cb01-e753-42af-8f22-29dd42060d04",
            "port": "we"
          },
          "target": {
            "block": "a1a43b56-ef28-4c6a-a7f7-bdb47cd1f373",
            "port": "we"
          }
        },
        {
          "source": {
            "block": "7902cb01-e753-42af-8f22-29dd42060d04",
            "port": "ioreq"
          },
          "target": {
            "block": "a1a43b56-ef28-4c6a-a7f7-bdb47cd1f373",
            "port": "ioreq"
          },
          "vertices": [
            {
              "x": 552,
              "y": 168
            }
          ]
        },
        {
          "source": {
            "block": "7902cb01-e753-42af-8f22-29dd42060d04",
            "port": "data_out"
          },
          "target": {
            "block": "f8016266-b629-4008-b686-0fe84a768cf5",
            "port": "data_in"
          },
          "vertices": [],
          "size": 8
        },
        {
          "source": {
            "block": "62d16b57-035c-4a86-b00d-7a19de9561c7",
            "port": "S1"
          },
          "target": {
            "block": "5e7621b5-809d-4478-9b4e-65071a6c8daa",
            "port": "in"
          },
          "size": 7
        },
        {
          "source": {
            "block": "62d16b57-035c-4a86-b00d-7a19de9561c7",
            "port": "S2"
          },
          "target": {
            "block": "021cb0ba-e841-4d9a-bc44-67810b81d710",
            "port": "in"
          },
          "size": 7
        }
      ]
    },
    "state": {
      "pan": {
        "x": 185.0622,
        "y": 288.8252
      },
      "zoom": 0.9544
    }
  },
  "dependencies": {}
}