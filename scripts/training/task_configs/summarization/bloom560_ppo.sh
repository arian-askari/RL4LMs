tokenizer:
  model_name: bigscience/bloom-560m
  padding_side: left
  truncation_side: left
  pad_token_as_eos_token: False

reward_fn:
  id: rouge
  args:
    rouge_type: "rouge1"

datapool:
  id: cnn_daily_mail
  args:
    prompt_prefix: "Summarize: "


env:
  n_envs: 10
  args:
    max_prompt_length: 200
    max_episode_length: 100
    terminate_on_eos: True
    prompt_truncation_side: "right"
    context_start_token: 0

alg:
  id: ppo
  args: 
    n_steps: 200
    batch_size: 2
    verbose: 1
    learning_rate: 0.000002
    n_epochs: 1
    ent_coef: 0.0
  kl_div:
    coeff: 0.001
    target_kl: 0.2
  policy:
    id: causal_lm_actor_critic_policy
    args:
      model_name: bigscience/bloom-560m
      apply_model_parallel: True
      prompt_truncation_side: "right"
      generation_kwargs:
        do_sample: True
        top_k: 50
        min_length: 50
        max_new_tokens: 100          
    
train_evaluation:
  do_evaluation: 0
  do_final_evaluation: 0
  eval_batch_size: 2
  n_iters: 1
  eval_every: 10
  save_every: 1
  metrics:
    #- id: meteor
    #  args: {}
    - id: rouge
    - id: bleu
      args: {}
