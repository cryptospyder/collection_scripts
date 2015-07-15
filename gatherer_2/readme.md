Gatherer
========

Introduction
------------
Gatherer is a DFIR data collection tool intended to simplify the evidence acquisition and triage process.
It is based heavily on David Cowen's dfirwizard which can be viewed on his github:
    https://github.com/dlcowen/dfirwizard/

Gatherer will be extended to include the following collection capabilities:
    - Full Disk Image
    - Memory Image
    - Volatile Data Collection

 It's likely that that some of the functionality will be come from third party utilities such as
 tools from the sysinternals suite and memory acquisition tool developed by others.

 In addition, the idea is to have a single collection code base that will intelligently determine
 which OS it's compiled or running on (pyinstaller) and will collect evidence appropriate for that
 specific system type.

 Usage
 -----

 gatherer.py <output directory>

 gatherer.exe <output directory>

