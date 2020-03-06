RSpec.describe FigureAncestor, type: :model do
  include_context 'Session'

  let(:world)     { build(:world) }

  figures = %i(figure          father        mother
               grandfather_m   grandmother_m
               grandfather_f   grandmother_f
               greatgrandfather              greatgrandmother
               son             daughter      grandson
               other_figure    other_father  other_son)
  figures.each do |i|
    let(i) { create(:figure, world: world, name: i.to_s) }
  end

  context 'in simple usage' do
    context 'with ancestors' do
      it 'add a parent to a figure' do
        fa = FigureAncestor.new(figure: figure, ancestor: father)
        expect(fa).to be_valid
        expect { fa.save! }.not_to raise_error
        expect(figure.figure_ancestors).to contain_exactly(fa)
        expect(father.figure_ancestors).not_to contain_exactly(fa)
        expect(figure.ancestors).to contain_exactly(father)
        expect(father.ancestors).not_to contain_exactly(figure)
        expect(father.figure_descendants).to contain_exactly(fa)
        expect(figure.figure_descendants).not_to contain_exactly(fa)
        expect(figure.descendants).not_to contain_exactly(figure)
        expect(father.descendants).to contain_exactly(figure)
      end

      it 'can add multiple ancestors' do
        figure.ancestors << mother << father
        expect(figure.ancestors).to contain_exactly(father, mother)
      end

      it 'cannot add same parent twice' do
        fa = FigureAncestor.create(figure: figure, ancestor: father)
        fb = FigureAncestor.new(figure: figure, ancestor: father)
        expect(fb).not_to be_valid
        expect { fb.save!(validate: false) }
          .to raise_error ActiveRecord::RecordNotUnique
      end

      it 'cannot add figure itself as an parent' do
        fa = FigureAncestor.new(figure: figure, ancestor: figure)
        expect(fa).not_to be_valid
        expect { fa.save!(validate: false) }
          .to raise_error ActiveRecord::StatementInvalid
      end

      it 'cannot add ancestors of different worlds', db_triggers: true do
        stranger = build_stubbed(:figure)
        expect(stranger.world).not_to eq(figure.world)
        invalid_ancestor = FigureAncestor
          .new(figure: figure, ancestor: stranger)
        expect(invalid_ancestor).not_to be_valid
        expect { invalid_ancestor.save!(validate: false) }
          .to raise_error ActiveRecord::StatementInvalid
      end

      # FIXME: Add test for 2nd degree ancestors
      # Adding an ancestor which in turn is a 2nd degree ancestor of a figure
      # lists this ancestor twice - as 1st and as 2nd degree
    end

    context 'with descendants' do
      it 'can add descendants to a figure' do
        figure.descendants << son << daughter
        expect(figure.descendants).to contain_exactly(son, daughter)
      end

      it 'cannot add figure istself as a child' do
        expect { figure.descendants << figure }
          .to raise_error ActiveRecord::RecordInvalid
      end

      it 'cannot add same child twice' do
        figure.descendants << son
        figure.save
        expect { figure.descendants << son }
          .to raise_error ActiveRecord::RecordInvalid
      end
    end
  end

  context 'in advanced usage' do
    before(:example) do
      figure.ancestors << mother << father
      figure.descendants << son << daughter
      father.ancestors << grandmother_m << grandfather_m
      mother.ancestors << grandmother_f << grandfather_f
      grandfather_m.ancestors << greatgrandmother << greatgrandfather
      son.descendants << grandson
      other_figure.descendants << other_son
      other_figure.ancestors << other_father
    end

    it 'can get complete pedigree' do
      pedigree = figure.pedigree
      expect(pedigree)
        .to contain_exactly(
          mother,             father,              son,
          daughter,           grandmother_m,       grandmother_f,
          grandfather_m,      grandfather_f,       greatgrandfather,
          greatgrandmother,   grandson
      )
      expect(pedigree)
        .not_to include(other_father, other_figure, other_son)
      # FIXME: The degrees are checked only with few samples ...
      expect((pedigree.find { |i| i == son }).degree).to eq(1)
      expect((pedigree.find { |i| i == greatgrandmother }).degree).to eq(-3)
    end

    it 'deletes all ancestor and descendant entries if figure is deleted' do
      ancestors = figure.ancestors
      descendants = figure.descendants
      expect(ancestors.count).to eq(2)
      expect(descendants.count).to eq(2)
      figure.destroy
      expect(FigureAncestor.find_by(ancestor: figure)).not_to be
      expect(FigureAncestor.find_by(figure: figure)).not_to be
      # FIXME: This seems not to be that performant
      ancestors.each do |ancestor|
        expect(ancestor.pedigree).not_to include(figure)
      end
      descendants.each do |descendant|
        expect(descendant.pedigree).not_to include(figure)
      end
    end

    it_behaves_like 'updates parents' do
      let(:parent)  { figure }
      let(:subject) { create(:figure_ancestor, figure: figure) }
    end

    it_behaves_like 'updates parents' do
      let(:parent)  { figure }
      let(:subject) { create(:figure_ancestor,
                             figure: father,
                             ancestor: figure) }
    end
  end
end
