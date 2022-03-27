// Name: 
// Student number: V00

public class MaxFrequencyHeap implements PriorityQueue {
	
	private static final int DEFAULT_CAPACITY = 10;
	private Entry[] data;
	private int size;
	
	public MaxFrequencyHeap() {
		data = new Entry[DEFAULT_CAPACITY];
		size = 0;
	}
	
	public MaxFrequencyHeap(int size) {
		data = new Entry[size];
		size = 0;
	}
	
	public void insert(Entry element) {
        if (size == data.length) {
            Entry[] newData = new Entry[size + DEFAULT_CAPACITY];
            for (int i = 0; i < size; i++) {
                newData[i] = data[i];
            }
            data = newData;
        }

        data[size] = element;

        for (int i = size; i > 0 && data[i].getFrequency() > data[(i-1)/2].getFrequency(); i = (i-1)/2) {
            swap(i, (i-1)/2); 
        }
        size++;

	}

    private void swap(int a, int b) {
        Entry temp = data[a];
        data[a] = data[b];
        data[b] = temp;
    }

	public Entry removeMax() { 
        if (isEmpty()) {
            return null;
        }
		Entry max = data[0];
        if (size > 1) {
            swap(0, size-1);
        }
        data[size-1] = null;
        size--;

        for (int i = 0; (((i*2)+1) < size || ((i*2)+2) < size);) {
            if (data[i].getFrequency() > data[(i*2)+1].getFrequency()) {
                break;
            } else if (((i*2)+2) < size && data[i].getFrequency() > data[(i*2)+2].getFrequency()) {
                break;      
            } else if ((i*2)+2 >= size || data[(i*2)+1].getFrequency() > data[(i*2)+2].getFrequency()) {
                swap(i, (i*2)+1);
                i = (i*2)+1;
            } else {
                swap(i, (i*2)+2);
                i = (i*2)+2;
            }// else
        }// for

        return max;
	}
	
	public boolean isEmpty() {
        return size == 0;
	}
	
	public int size() {
		return size;
	}

}
 
