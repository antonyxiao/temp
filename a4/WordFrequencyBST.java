// Name: 
// Student number: V00

public class WordFrequencyBST {
	private TreeNode root;
	private int numElements;
	
	public WordFrequencyBST() {
		root = null;
		numElements = 0;
	}
	
	/*
	 * Purpose: Update the BST by handling input word 
	 * Parameters: String word - The new word to handle
	 * Returns: Nothing
	 * Explanation: If there is no entry in the tree 
	 *   representing the word, then the a new entry 
	 *   should be created and placed into the correct 
	 *   location of the BST. Otherwise, the existing
	 *   entry for the word should have its frequency
	 *   value incremented. 
	 */	
	public void handleWord(String word) {
        TreeNode node = getNodeFromWord(root, word);
        if (node == null) {
            Entry newEntry = new Entry(word);
            insert(newEntry);
        } else {
            node.getData().addToFrequency();
        }

    }

    /*
	 * Purpose: Get the frequency value of the given word
	 * Parameters: String word - the word to find
	 * Returns: int - the word's associated frequency
	 */	
	public int getFrequency(String word) {
        TreeNode result = getNodeFromWord(root, word);

        if (result == null) {
            return 0;
        } else {
            return result.getData().getFrequency();
        }
	}

    private TreeNode getNodeFromWord(TreeNode root, String word) {
        TreeNode cur = root;
        while (cur != null) {
            if (word.compareTo(cur.getData().getWord()) > 0) {
                cur = cur.right;
            } else if (word.compareTo(cur.getData().getWord()) < 0) {
                cur = cur.left;
            } else {
                return cur;
            }
        }
        return null;
    }

    public void insert(Entry newEntry) {
        TreeNode newNode = new TreeNode(newEntry);
        TreeNode cur = root;
        if (root == null) {
           root = newNode;
        } else {
           while (true) {
                if (newEntry.getWord().compareTo(cur.getData().getWord()) > 0) {
                   if (cur.right != null) {
                        cur = cur.right;
                   } else {
                       cur.right = newNode;
                       break;
                   }
                } else if (newEntry.getWord().compareTo(cur.getData().getWord()) < 0) {
                   if (cur.left != null) {
                       cur = cur.left;
                   } else {
                       cur.left = newNode;
                       break;
                   }
                } else {
                   break;
               }
           }// while
       }// else
	}// inserts

	/****************************************************
	* Helper functions for Insertion and Search testing *
	****************************************************/
	
	public String inOrder() {
		if (root == null) {
			return "empty";
		}
		return "{" + inOrderRecursive(root) + "}";
	}
	
	public String inOrderRecursive(TreeNode cur) {
		String result = "";
		if (cur.left != null) {
			result = inOrderRecursive(cur.left) + ",";
		} 
		result += cur.getData().getWord();
		if (cur.right != null) {
			result += "," + inOrderRecursive(cur.right);
		}
		return result;
	}
	
	public String preOrder() {
		if (root == null) {
			return "empty";
		}
		return "{" + preOrderRecursive(root) + "}";
	}
	
	public String preOrderRecursive(TreeNode cur) {
		String result = cur.getData().getWord();
		if (cur.left != null) {
			result += "," + preOrderRecursive(cur.left);
		} 
		if (cur.right != null) {
			result += "," + preOrderRecursive(cur.right);
		}
		return result;
	}
	
	/****************************************************
	* Helper functions to populate a Heap from this BST *
	****************************************************/
	
	public MaxFrequencyHeap createHeapFromTree() {
		MaxFrequencyHeap maxHeap = new MaxFrequencyHeap(numElements+1);
		addToHeap(maxHeap, root);
		return maxHeap;
	}
	
	public void addToHeap(MaxFrequencyHeap h, TreeNode n) {
		if (n != null) {
			addToHeap(h, n.left);
			h.insert(n.getData());
			addToHeap(h, n.right);
		}
	}		
}
