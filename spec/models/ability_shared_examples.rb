shared_examples_for 'project manager' do
  let(:participant) { Fabricate :participant, project: project }
  let(:locked_project) { project.tap{|p| p.stub(:editable?)} }

  context 'chairs' do
    it { should     be_able_to :read, project.chair }
    it { should_not be_able_to :read, Chair.new }
  end

  context 'projects' do
    it { should     be_able_to :read, project }
    it { should     be_able_to :update, project }
    context 'locked' do
      it { should     be_able_to :read,      locked_project }
      it { should_not be_able_to :update,    locked_project }
      it { should_not be_able_to :close,     locked_project }
      it { should_not be_able_to :to_close,  locked_project }
      it { should_not be_able_to :destroy,   locked_project }
    end
  end

  context 'participants' do
    it { should     be_able_to :create,  project.participants.new }
    it { should     be_able_to :remove,  project.participants.new }
    it { should     be_able_to :cancel,  project.participants.new }
    it { should_not be_able_to :approve, project.participants.new }
    context 'in locked project' do
      it { should     be_able_to :create,  locked_project.participants.new }
      it { should     be_able_to :remove,  locked_project.participants.new }
      it { should     be_able_to :cancel,  locked_project.participants.new }
      it { should_not be_able_to :approve, locked_project.participants.new }
    end
  end

  it { should     be_able_to :manage, project.stages.new }
  it { should     be_able_to :manage, participant.issues.new }
  context 'in locked project' do
    it { should     be_able_to :manage, locked_project.stages.new }
  end
end
