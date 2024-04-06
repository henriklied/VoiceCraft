#!/bin/bash
mkdir -p extracted_codes_and_phonemes hf_downloads saves
wget -c https://huggingface.co/pyp1/VoiceCraft/resolve/main/encodec_4cb2048_giga.th -P pretrained_models/
wget -c https://huggingface.co/pyp1/VoiceCraft/resolve/main/gigaHalfLibri330M_TTSEnhanced_max16s.pth -P pretrained_models/
wget -c https://huggingface.co/datasets/pyp1/VoiceCraft_RealEdit/resolve/main/train.txt -P extracted_codes_and_phonemes/
wget -c https://huggingface.co/datasets/pyp1/VoiceCraft_RealEdit/raw/main/validation.txt -P extracted_codes_and_phonemes/
wget -c https://huggingface.co/datasets/pyp1/VoiceCraft_RealEdit/raw/main/vocab.txt -P extracted_codes_and_phonemes/
cd data
python phonemize_encodec_encode_hf.py \
--download_to ../hf_downloads \
--encodec_model_path ../extracted_codes_and_phonemes \
--encodec_model_path ../pretrained_models/encodec_4cb2048_giga.th \
--mega_batch_size 60 \
--batch_size 16 \
--max_len 20000 \
--save_dir ../saves
