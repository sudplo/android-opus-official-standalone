package com.theeasiestway.opus

import androidx.annotation.IntRange

object Constants {
    class SampleRate private constructor(val v: Int) { 
        companion object { 
            fun _8000() = SampleRate(8000)
            fun _12000() = SampleRate(12000)
            fun _16000() = SampleRate(16000)
            fun _24000() = SampleRate(24000)
            fun _48000() = SampleRate(48000) 
        } 
    }
    class Channels private constructor(val v: Int) { 
        companion object { 
            fun mono() = Channels(1)
            fun stereo() = Channels(2) 
        } 
    }
    class Application private constructor(val v: Int) { 
        companion object { 
            fun voip() = Application(2048) 
            fun audio() = Application(2049)
            fun restrictedLowdelay() = Application(2051)
        } 
    }
    class FrameSize private constructor(val v: Int) { 
        companion object { 
            fun _120() = FrameSize(120)
            fun _240() = FrameSize(240)
            fun _480() = FrameSize(480) 
            fun _960() = FrameSize(960)
            fun _1920() = FrameSize(1920)
            fun _2880() = FrameSize(2880)
        } 
    }
    class Bitrate private constructor(val v: Int) { 
        companion object { 
            fun instance(v: Int) = Bitrate(v) 
        } 
    }
    class Complexity private constructor(val v: Int) { 
        companion object { 
            fun instance(@IntRange(from = 0, to = 10) v: Int) = Complexity(v) 
        } 
    }
}
