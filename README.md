# SocialSync_Power
Data Processing scripts for the analysis that accompanies: Fitzpatrick, et al, *Alpha band signatures of social synchrony*.

## Workflow
1. Acquire Data
2. "Using NetStation software, data were segmented with a 500 ms baseline and a 45000 ms post-stimulus epoch, high pass filtered at .3 Hz, and re-referenced offline to the average across scalp electrodes."
3. Netstation files imported into EEGLAB
3. **DIN_Decoder.m** is used to get the task description for each epoch
4. EEG Data is broken-up into 'epochs', separate EEGLAB files saved for each epoch (**epochize_v1.m**)
5. EEGLAB "Reject continuous data by eye" was used to reject artifacts
6. **Power_Bands.m** is then used to calculate the power, per band (AlphaHigh and AlphaLow), per subject, per electrode per epoch and generate an output file.

