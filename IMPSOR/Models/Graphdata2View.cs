﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IMPSOR
{
    public class GraphData2View
    {
        public int? x { get; set; }
        public int? y { get; set; }
        public int? z { get; set; }
        public string color { get; set; }
        public double percentage { get; set; }
        public string pname { get; set; }
    }
    public class GraphJson
    {
        
        public string Jsoncadena { get; set; }
        public String Titulo { get; set; }
        public String Subtitulo { get; set; }
    }

}