describe FHIR::ElementDefinition do

  shared_context 'choice of type' do
    let(:element_definition) do
      FHIR::ElementDefinition.new(path: 'Patient.deceased[x]', type: [{code: 'boolean'}, {code: 'dateTime'}])
    end
  end

  shared_context 'single type' do
    let(:element_definition) do
      FHIR::ElementDefinition.new(path: 'Patient.deceased', type: [{code: 'boolean'}])
    end
  end
  describe '#choice_type' do
    context 'with a choice of types' do
      include_context 'choice of type'
      it 'indicates there is a choice of type' do
        expect(element_definition.choice_type?).to be true
      end
    end

    context 'with a single type' do
      include_context 'single type'
      it 'indicates there is not a choice of types' do
        expect(element_definition.choice_type?).to be false
      end
    end
  end

  describe '#type_code' do
    context 'with a single type' do
      include_context 'single type'
      it 'provides the expected type of the element' do
        expect(element_definition.type_code).to eq('boolean')
        expect(element_definition.type_code('fake.path')).to eq('boolean')
      end
    end
    context 'with a choice of types' do
      include_context 'choice of type'
      it 'provides the correct type from the choices' do
        expect(element_definition.type_code('Patient.deceasedBoolean')).to eq('boolean')
        expect(element_definition.type_code('Patient.deceasedDateTime')).to eq('dateTime')
      end

      it 'returns an UnknownType exception if path is not provided' do
        expect { element_definition.type_code }.to raise_error(FHIR::UnknownType)
      end

      it 'returns an UnknownType exception if none of the types match' do
        expect { element_definition.type_code('Patient.deceasedBoatLength') }.to raise_error(FHIR::UnknownType,
                                                                                             'No matching types from ["boolean", "dateTime"] for element at Patient.deceasedBoatLength')
      end
    end
  end
end