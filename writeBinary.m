function writeBinary(model_path)
% ��ģ�������Զ����Ʒ�ʽд���ļ��У������������Ե���
%   model_path Ϊģ���ļ�����Ŀ¼�� models ����
outfile = 'models/model.bin';
load(model_path);
fd = fopen(outfile, 'wb'); % overwrite if exists

% д��ģ�ͻ�������
T = regModel.T;
[regSize, fernSize] = size(regModel.regs(1).regInfo);
landmarkSize = regModel.model.nfids;
landmarkDim = regModel.model.D;
M = size(regModel.regs(1).regInfo{1, 1}.thrs, 2);
featureSize = regModel.regs(1).ftrPos.F;
N = size(regModel.pGtN,1);
fwrite(fd, T, 'int32');
fwrite(fd, regSize, 'int32');
fwrite(fd, fernSize, 'int32');
fwrite(fd, landmarkSize, 'int32');
fwrite(fd, landmarkDim, 'int32');
fwrite(fd, M, 'int32');
fwrite(fd, featureSize, 'int32');
fwrite(fd, N, 'int32');

% д��ƽ����״
for i=1:landmarkDim
    fwrite(fd, regModel.pStar(1, i), 'float32');
end
% д��ѵ��ʱ����״
for i=1:N
    for j=1:landmarkDim
        fwrite(fd, regModel.pGtN(i, j), 'float32');
    end
end

% д��ģ�Ͳ���
for i=1:T
    fprintf('����д��� %i ���ع�������\n', i)
    % ��д�������� id1, id2, t1
    % ѡ���������ţ��ֳ����У��������Ŵ� 0 ��ʼ
    xs = regModel.regs(i).ftrPos.xs;
    for j=1:featureSize
        % �ؼ����Ŵ� 0 ��ʼ
        fwrite(fd, xs(j, 1)-1, 'int32');
        fwrite(fd, xs(j, 2)-1, 'int32');
        fwrite(fd, xs(j, 3), 'float32');
    end
    % д������ʲ��� 15x3
    for r=1:regSize
        for c=1:fernSize
            reg = regModel.regs(i).regInfo{r, c};
            % ѡ���������ţ��ֳ����У��������Ŵ� 0 ��ʼ
            for m=1:M
                fwrite(fd, reg.fids(1, m)-1, 'int32');
            end
            for m=1:M
                fwrite(fd, reg.fids(2, m)-1, 'int32');
            end
            % ����ֵ��ֵ
            for m=1:M
                fwrite(fd, reg.thrs(1, m), 'float32');
            end
            % �����Ҷ�ڵ����״����
            for k=1:2^M
                for p=1:landmarkDim
                    fwrite(fd, reg.ysFern(k, p), 'float32');
                end
            end
        end
    end
end

% �ر��ļ�
fclose(fd);
end

