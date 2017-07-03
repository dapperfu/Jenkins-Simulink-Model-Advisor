now_ = sprintf('%f',now);
randi_ = sprintf('%d', randi([0, 10], 1));
fprintf('now=%s\n',now_);
setenv('NOW',now_)

fprintf('randi=%s\n',randi_);
setenv('RANDI',randi_)
exit(0);
