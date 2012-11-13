shared_examples_for 'project manager' do
  let(:participant) { Fabricate :participant, project: project }
  context 'chairs' do
    it { should     be_able_to :read, project.chair }
    it { should_not be_able_to :read, Chair.new }
  end

  context 'projects' do
    it { should     be_able_to :read, project }
    it { should     be_able_to :update, project }
  end

  context 'participants' do
    it { should     be_able_to :create,  project.participants.new }
    it { should     be_able_to :remove,  project.participants.new }
    it { should     be_able_to :cancel,  project.participants.new }
    it { should_not be_able_to :approve, project.participants.new }
  end

  it { should     be_able_to :manage, project.stages.new }
  it { should     be_able_to :manage, participant.issues.new }
end
