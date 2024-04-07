#!/bin/bash
# source ~/miniconda3/etc/profile.d/conda.sh
# conda activate voicecraft
export CUDA_VISIBLE_DEVICES=1,2
export WORLD_SIZE=2

dataset=nst-ostlandsk_v3
mkdir -p ./logs/${dataset}

exp_root="../experiments/"
exp_name=e330M
dataset_dir="../saves/nst-ostlandsk_v3/" # xs if you only extracted xs in previous step
encodec_codes_folder_name="encodec_16khz_4codebooks"

# export CUDA_LAUNCH_BLOCKING=1 # for debugging

torchrun --nnodes=1 --rdzv-backend=c10d --rdzv-endpoint=localhost:41977 --nproc_per_node=${WORLD_SIZE} \
../main.py \
--reduced_eog 1 \
--drop_long 1 \
--eos 2051 \
--n_special 4 \
--pad_x 0 \
--codebook_weight '[2,1,1,1]' \
--encodec_sr 50 \
--num_steps 500000 \
--lr 1e-05 \
--warmup_fraction 0.1 \
--optimizer_name "AdamW" \
--pseudo_epoch_size 3000 \
--reduce_lr_start_step 3000 \
--reduce_lr_start_epoch 4 \
--clipping_update_period 1000 \
--d_model 1024 \
--audio_embedding_dim 1024 \
--nhead 16 \
--num_decoder_layers 24 \
--max_num_tokens 20000 \
--gradient_accumulation_steps 24 \
--val_max_num_tokens 6000 \
--num_buckets 10 \
--audio_max_length 16 \
--audio_min_length 1 \
--text_max_length 400 \
--text_min_length 10 \
--mask_len_min 1 \
--mask_len_max 600 \
--tb_write_every_n_steps 100 \
--print_every_n_steps 400 \
--val_every_n_steps 1600 \
--text_vocab_size 120 \
--text_pad_token 120 \
--phn_folder_name "phonemes" \
--manifest_name "manifest" \
--encodec_folder_name ${encodec_codes_folder_name} \
--audio_vocab_size 2048 \
--empty_token 2048 \
--eog 2049 \
--audio_pad_token 2050 \
--n_codebooks 4 \
--max_n_spans 3 \
--shuffle_mask_embedding 0 \
--mask_sample_dist poisson1 \
--max_mask_portion 0.9 \
--min_gap 5 \
--num_workers 8 \
--dynamic_batching 1 \
--dataset $dataset \
--exp_dir "${exp_root}/${dataset}/${exp_name}" \
--dataset_dir ${dataset_dir} \
--load_model_from './pretrained_models/giga330M.pth' \
--seed 1 \
--precision 'float16' \
--num_epochs 10 \
--gradient_clip_val 1.0 
#--early_stop_step 3200 \
# --early_stop_threshold -1.0
#  >> ./logs/${dataset}/${exp_name}.log 2>&1
