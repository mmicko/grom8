{
  "version": "1.1",
  "package": {
    "name": "Grom-8 CPU",
    "version": "1.0",
    "description": "Grom-8 CPU Core",
    "author": "Miodrag Milanovic",
    "image": "%3Csvg%20height=%22512%22%20viewBox=%220%200%20512%20512%22%20width=%22512%22%20xmlns=%22http://www.w3.org/2000/svg%22%3E%3Cpath%20d=%22M199%20387h-62.218c-.221%200%20.221%200%200%200C91.805%20387%2056%20350.337%2056%20305.36c0-44.977%2036.456-81.537%2081.433-81.537%203.922%200%207.778.222%2011.557.769%2013.941-56.938%2065.316-99.218%20126.554-99.218%2071.961%200%20130.293%2058.319%20130.293%20130.28%200%2010.593-1.264%2020.879-3.661%2030.743%201.212-.091%202.423-.03%203.661-.03%2027.7%200%2050.163%2022.563%2050.163%2050.263S433.537%20387%20405.837%20387H338%22%20fill=%22none%22%20stroke=%22#000%22%20stroke-miterlimit=%2210%22%20stroke-width=%2230%22/%3E%3Cpath%20stroke=%22#000%22%20stroke-linecap=%22round%22%20stroke-miterlimit=%2210%22%20stroke-width=%224%22%20d=%22M286.705%20270.678l-71.022%20100.615%2059.185%2026.633-38.47%2088.53%2082.858-97.408-62.144-35.511z%22/%3E%3C/svg%3E"
  },
  "design": {
    "board": "go-board",
    "graph": {
      "blocks": [
        {
          "id": "60084d58-17f4-4238-a8eb-1b3dc4f1bb84",
          "type": "basic.output",
          "data": {
            "name": "addr",
            "range": "[11:0]",
            "pins": [
              {
                "index": "11",
                "name": "",
                "value": "0"
              },
              {
                "index": "10",
                "name": "",
                "value": "0"
              },
              {
                "index": "9",
                "name": "",
                "value": "0"
              },
              {
                "index": "8",
                "name": "",
                "value": "0"
              },
              {
                "index": "7",
                "name": "",
                "value": "0"
              },
              {
                "index": "6",
                "name": "",
                "value": "0"
              },
              {
                "index": "5",
                "name": "",
                "value": "0"
              },
              {
                "index": "4",
                "name": "",
                "value": "0"
              },
              {
                "index": "3",
                "name": "",
                "value": "0"
              },
              {
                "index": "2",
                "name": "",
                "value": "0"
              },
              {
                "index": "1",
                "name": "",
                "value": "0"
              },
              {
                "index": "0",
                "name": "",
                "value": "0"
              }
            ],
            "virtual": true
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
            "pins": [
              {
                "index": "0",
                "name": "",
                "value": "0"
              }
            ],
            "virtual": true,
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
            "pins": [
              {
                "index": "7",
                "name": "",
                "value": "0"
              },
              {
                "index": "6",
                "name": "",
                "value": "0"
              },
              {
                "index": "5",
                "name": "",
                "value": "0"
              },
              {
                "index": "4",
                "name": "",
                "value": "0"
              },
              {
                "index": "3",
                "name": "",
                "value": "0"
              },
              {
                "index": "2",
                "name": "",
                "value": "0"
              },
              {
                "index": "1",
                "name": "",
                "value": "0"
              },
              {
                "index": "0",
                "name": "",
                "value": "0"
              }
            ],
            "virtual": true
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
            "pins": [
              {
                "index": "0",
                "name": "",
                "value": "0"
              }
            ],
            "virtual": true,
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
            "name": "we",
            "pins": [
              {
                "index": "0",
                "name": "",
                "value": "0"
              }
            ],
            "virtual": true
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
            "name": "ioreq",
            "pins": [
              {
                "index": "0",
                "name": "",
                "value": "0"
              }
            ],
            "virtual": true
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
            "pins": [
              {
                "index": "7",
                "name": "",
                "value": "0"
              },
              {
                "index": "6",
                "name": "",
                "value": "0"
              },
              {
                "index": "5",
                "name": "",
                "value": "0"
              },
              {
                "index": "4",
                "name": "",
                "value": "0"
              },
              {
                "index": "3",
                "name": "",
                "value": "0"
              },
              {
                "index": "2",
                "name": "",
                "value": "0"
              },
              {
                "index": "1",
                "name": "",
                "value": "0"
              },
              {
                "index": "0",
                "name": "",
                "value": "0"
              }
            ],
            "virtual": true,
            "clock": false
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
            "name": "hlt",
            "pins": [
              {
                "index": "0",
                "name": "",
                "value": "0"
              }
            ],
            "virtual": true
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
  },
  "dependencies": {}
}